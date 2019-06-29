defmodule ErlefWeb.Router do
  use ErlefWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ErlefWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/about", PageController, :about

    get "/bylaws", PageController, :bylaws

    get "/faq", PageController, :faq

    get "/contact", PageController, :contact

    get "/wg", PageController, :working_groups

    get "/wg/marketing", PageController, :marketing

    get "/sponsors", PageController, :sponsors

    get "/wg/sponsorship", PageController, :sponsorship

    get "/wg/fellowship", PageController, :fellowship

    get "/wg/observability", PageController, :observability

    get "/wg/building", PageController, :building
  end
end
