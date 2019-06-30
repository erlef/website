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

    for {page, _t} <- ErlefWeb.PageController.static_pages() do
      get page, PageController, :page
    end
  end
end
