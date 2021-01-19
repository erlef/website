defmodule ErlefWeb.Router do
  use ErlefWeb, :router
  use Honeybadger.Plug
  import Phoenix.LiveDashboard.Router

  @trusted_sources ~w(
    use.fontawesome.com platform.twitter.com syndication.twitter.com
    syndication.twitter.com/settings cdn.syndication.twimg.com
    licensebuttons.net i.creativecommons.org
    pbs.twimg.com use.typekit.net p.typekit.net
    event-org-images.ewr1.vultrobjects.com sponsors.ewr1.vultrobjects.com erlef.matomo.cloud cdn.rawgit.com
    127.0.0.1:9998 cdn.datatables.net user.fm cdnjs.cloudflare.com uicdn.toast.com/
  )

  @trusted_connect_sources ~w(https://user.fm https://www.erlef.org wss://erlef.org 
    wss://www.erlef.org ws://erlef.org ws://www.erlef.org  https://erlef.matomo.cloud)

  if Erlef.in_env?([:dev, :test]) do
    @default_source Enum.join(@trusted_sources ++ ["127.0.0.1:9998"], " ")
    @default_connect_source Enum.join(@trusted_connect_sources ++ ["127.0.0.1:9998"], " ")
  else
    @default_source Enum.join(@trusted_sources, " ")
    @default_connect_source Enum.join(@trusted_connect_sources, " ")
  end

  @connect_src "connect-src 'self' #{@default_connect_source}"

  @csp "default-src 'self' 'unsafe-eval' 'unsafe-inline' data: #{@default_source}; #{@connect_src}"

  pipeline :api do
    plug :accepts, ["json"]
    plug ErlefWeb.Plug.API.Auth
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug ErlefWeb.Plug.Attack
    plug ErlefWeb.Plug.Session
    plug :put_secure_browser_headers, %{"content-security-policy" => @csp}
  end

  pipeline :admin_required do
    plug :put_layout, {ErlefWeb.Admin.LayoutView, "app.html"}
    plug ErlefWeb.Plug.RequiresAdmin
  end

  pipeline :session_required do
    plug ErlefWeb.Plug.Authz
  end

  pipeline :working_group do
    plug ErlefWeb.Plug.CurrentWorkingGroup
    plug ErlefWeb.Plug.Authz.Volunteer
  end

  pipeline :chair_required do
    plug ErlefWeb.Plug.Authz.Chair
  end

  if Erlef.is_env?(:dev) do
    scope "/dev" do
      pipe_through [:browser]
      forward "/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox"
    end
  end

  scope "/", ErlefWeb do
    pipe_through :browser

    get "/login/init", SessionController, :show
    get "/login", SessionController, :create
    post "/logout", SessionController, :delete

    get "/", PageController, :index
    get "/academic-papers", AcademicPaperController, :index
    get "/bylaws", PageController, :bylaws
    get "/board_members", PageController, :board_members
    get "/community", PageController, :community
    get "/contact", PageController, :contact
    get "/faq", PageController, :faq
    get "/fellows", PageController, :fellows
    get "/sponsors", PageController, :sponsors
    get "/become-a-sponsor", PageController, :sponsor_info
    get "/wg-proposal-template", PageController, :wg_proposal_template
    get "/all_calendars", PageController, :all_calendars

    # NOTE: News routes are still in place for links that may be out there.
    # Please use blog routes. 
    get "/news", BlogController, :index, as: :news
    get "/news/:topic", BlogController, :index, as: :news
    get "/news/:topic/:id", BlogController, :show, as: :news

    get "/blog/tags/:tag", BlogController, :tags, as: :blog
    get "/blog/:topic", BlogController, :index, as: :blog
    get "/blog/:topic/:id", BlogController, :show, as: :blog

    get "/events/:slug", EventController, :show
    get "/events", EventController, :index

    resources "/wg", WorkingGroupController, only: [:index, :show], param: "slug"

    get "/wg/:slug/calendar", WorkingGroupController, :calendar

    resources "/stipends", StipendController, only: [:index, :create]

    resources "/slack-invite/:team", SlackInviteController, only: [:create, :index]

    scope "/wg/:slug", WorkingGroup, as: :working_group do
      pipe_through [:session_required, :working_group]
      resources "/reports", ReportController
    end

    scope "/wg/:slug/settings", WorkingGroup, as: :working_group do
      pipe_through [:session_required, :working_group, :chair_required]

      get "/edit", SettingsController, :edit

      put "/", SettingsController, :update

      put "/chairs/:volunteer_id",
          SettingsController,
          :create_chair

      delete "/chairs/:volunteer_id",
             SettingsController,
             :delete_chair

      delete "/volunteers/:volunteer_id",
             SettingsController,
             :delete_volunteer
    end

    scope "/members", Members, as: :members do
      pipe_through [:session_required]
      resources "/profile", ProfileController, only: [:show], singleton: true
      resources "/email_requests", EmailRequestController
    end

    scope "/admin", Admin, as: :admin do
      pipe_through [:admin_required]
      get "/", DashboardController, :index
      resources "/events", EventController, only: [:index, :show]
      resources "/email_requests", EmailRequestController, only: [:index, :show]
      post "/email_requests/assign", EmailRequestController, :assign
      post "/email_requests/complete", EmailRequestController, :complete
      put "/events/:id", EventController, :approve

      resources "/sponsors", SponsorController

      resources "/wg", WorkingGroupController

      put "/wg/:id/chairs/:volunteer_id",
          WorkingGroupController,
          :create_chair

      delete "/wg/:id/chairs/:volunteer_id",
             WorkingGroupController,
             :delete_chair

      delete "/working_groups/:id/volunteers/:volunteer_id",
             WorkingGroupController,
             :delete_volunteer

      resources "/volunteers", VolunteerController

      live_dashboard "/live-dashboard",
        metrics: ErlefWeb.Telemetry,
        ecto_repos: [Erlef.Repo]
    end
  end

  scope "/api/v1", ErlefWeb.API.V1, as: :api_v1 do
    pipe_through :api

    scope "/members/:id", Member, as: :member do
      resources "/working_groups", WorkingGroupController, only: [:index]
    end
  end

  scope "/", ErlefWeb do
    pipe_through [:session_required, :working_group]
  end

  scope "/", ErlefWeb do
    pipe_through [:browser, :session_required]
    resources "/event_submissions", EventSubmissionController, only: [:new, :show, :create]
  end
end
