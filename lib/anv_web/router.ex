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

    # Only available  for volunteers; admins would  see on
    # their pages anyway
    get "/", PageController, :index
    # post "/reserve", PageController, :reserve

    # The sign-in form has a checkbox if one wants to sign
    # in as admin.
    resources(
      "/sessions",
      SessionController,
      only: [:new, :create, :delete],
      singleton: true
    )
  end

  scope "/signup" do
    # TODO add `fetch_query_params/2`?
    # TODO implement AuthenticateSignup

    # Could've just  put this  in the  "/" scope  and plug
    # `AuthenticateSignup` in `SignupController`, but this
    # way I can see quickly  what auth plugs are there and
    # at what points.
    pipe_through [:browser, ANVWeb.Auth.AuthenticateSignup]
    resources "/", SignupController, [:new, :create]
  end

  scope "/admin", ANVWeb do
    pipe_through [:browser, ANVWeb.Auth.AuthorizeAdmin]

    # NOTE on adding users:
    # when  adding volunteers,  just specify  `res_dev_id`
    # and email address to create signup link and email it
    # to them.

    get "/", AdminController, :index

    # TODO Cull these resources with `:only`

    resources "/users",    UserController
    resources "/ads",      AdsController
    resources "/articles", ArticleController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ANVWeb do
  #   pipe_through :api
  # end
end
