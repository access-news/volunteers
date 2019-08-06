defmodule ANVWeb.Router do
  use ANVWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ANVWeb.Auth.AssignCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ANVWeb do
    pipe_through :browser

    get "/", PageController, :index
    # post "/reserve", PageController, :reserve

    # TODO:
    # Half  of "/users" resources  (i.e., :index and :show, see UserController)  needs auth.
    # Leave it as  it is, or split it here  in the Router instead?
    # :show and  :index can  go under "/manage"  anyway as
    # basically  it  is  an  admin  thing.  Or  create  an
    # "/admin" scope for admin stuff?
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/signup" do
    # TODO add `fetch_query_params/2`?
    pipe_through [:browser, ANVWeb.Auth.AuthenticateSignup]
    resources "/", VolunteerController, [:new, :create]
  end

  # TODO:
  # route to login page (that has a "register" button as
  # well) for all anon visits to pages that require auth

  scope "/admin", ANVWeb do
    pipe_through [:browser, ANVWeb.Auth.AuthorizeAdmin]

    # Admins should also  be able to add  new users, hence
    # no `:only` cluase
    resources "/users", UserController
  end

  scope "/articles", ANVWeb do
    pipe_through [:browser, ANVWeb.Auth.AuthorizeUser]
    resources
  end

  # scope "/manage", ANVWeb do
  #   pipe_through [:browser, ANVWeb.Auth.AuthenticateUser]

  #   resources "/recordings", RecordingController
  # end

  # Other scopes may use custom stacks.
  # scope "/api", ANVWeb do
  #   pipe_through :api
  # end
end
