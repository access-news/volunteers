defmodule ANVWeb.Auth.AuthorizeAdmin do

  import Plug.Conn
  import Phoenix.Controller
  alias ANVWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  # TODO: redirect to the original page after login

  def call(conn, _opts) do

    if ANVWeb.Auth.is_admin?(conn) do
      conn
    else
      conn
      |> put_flash(
           :error,
          "You need admin privileges to access that page"
         )
      # |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
