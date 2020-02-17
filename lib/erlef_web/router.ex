defmodule ErlefWeb.Router do
  use ErlefWeb, :router

  @trusted_sources ~w(www.google.com www.googletagmanager.com  www.google-analytics.com
    fonts.gstatic.com www.gstatic.com fonts.googleapis.com use.fontawesome.com
    stackpath.bootstrapcdn.com use.fontawesome.com platform.twitter.com
    code.jquery.com platform.twitter.com syndication.twitter.com
    syndication.twitter.com/settings cdn.syndication.twimg.com
    licensebuttons.net i.creativecommons.org platform.twitter.com
    pbs.twimg.com syndication.twitter.com www.googleapis.com
  )

  @default_source Enum.join(@trusted_sources, " ")

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug ErlefWeb.PlugAttack

    plug :put_secure_browser_headers, %{
      "content-security-policy" =>
        " default-src 'self' 'unsafe-eval' 'unsafe-inline' data: #{@default_source}"
    }

    plug ErlefWeb.Plug.JsonEvents
  end

  if Erlef.is_env?(:dev) do
    scope "/dev" do
      pipe_through [:browser]
      forward "/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox"
    end
  end

  scope "/", ErlefWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/academic-papers", PageController, :academic_papers
    get "/bylaws", PageController, :bylaws
    get "/board_members", PageController, :board_members
    get "/contact", PageController, :contact
    get "/faq", PageController, :faq
    get "/sponsors", PageController, :sponsors
    get "/become-a-sponsor", PageController, :sponsor_info
    get "/wg-proposal-template", PageController, :wg_proposal_template

    get "/news", BlogController, :index, as: :news
    get "/news/:topic", BlogController, :index, as: :news
    get "/news/:topic/:id", BlogController, :show, as: :news

    resources "/events", EventController, only: [:index, :show]
    resources "/wg", WorkingGroupController, only: [:index, :show]
    resources "/stipends", StipendController, only: [:index, :create]

    resources "/slack-invite/:team", SlackInviteController, only: [:create, :index]
  end
end
