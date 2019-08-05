defmodule ANVWeb.Auth do

  import Plug.Conn
  import Phoenix.Controller
  alias ANVWeb.Router.Helpers, as: Routes

  # --- MODULE PLUG PART ----

  def init(opts), do: opts

  # TODO Clever and short, but make it explicit.
  def call(conn, _opts) do
    # Is there a user ID present in the session?
    user_id = get_session(conn, :user_id)
    # Does the present user ID have a corresponding entry in the backend?
    user = user_id && ANV.Accounts.get_user(user_id)

    assign(conn, :current_user, user)
  end

  # --- FUNCTION PLUGS ----

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
