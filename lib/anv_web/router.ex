defmodule ANVWeb.Router do
  use ANVWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    # get "/", PageController, :index
  end

  scope "/", ANVWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/reserve", PageController, :reserve
    # post "/reserve_all", PageController, :reserve
    # resources "/ads", AdsController, only: [:index, :new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ANVWeb do
  #   pipe_through :api
  # end
end
