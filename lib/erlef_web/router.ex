defmodule ErlefWeb.Router do
  use ErlefWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ErlefWeb.Plug.JsonEvents
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
  end

  if Erlef.Config.env() == :dev do
    scope "/dev" do
      pipe_through [:browser]
      forward "/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox"
    end
  end

  scope "/", ErlefWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :about
    get "/bylaws", PageController, :bylaws
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
    resources "/grants", GrantController, only: [:index, :create]
  end

  scope "/api/grants", ErlefWeb do
    pipe_through :api
    post "/", GrantApiController, :create
  end
end
