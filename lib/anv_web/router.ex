defmodule ANVWeb.Router do
  use ANVWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ANVWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ANVWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/reserve", PageController, :reserve
    # post "/reserve_all", PageController, :reserve
    # resources "/ads", AdsController, only: [:index, :new, :create, :delete]

    # TODO:
    # Half  of "/users" resources  (i.e., :index and :show, see UserController)  needs auth.
    # Leave it as  it is, or split it here  in the Router instead?
    # :show and  :index can  go under "/manage"  anyway as
    # basically  it  is  an  admin  thing.  Or  create  an
    # "/admin" scope for admin stuff?
    resources "/users",    UserController,    only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # TODO:
  # route to login page (that has a "register" button as
  # well) for all anon visits to pages that require auth

  scope "/manage", ANVWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/recordings", RecordingController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ANVWeb do
  #   pipe_through :api
  # end
end
