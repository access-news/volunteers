defmodule ANVWeb.Auth do

  import Plug.Conn

  def login(conn, %user_type{} = user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def is_admin?(conn) do

    user = conn.assigns.current_user

    signed_in?(conn) && ANV.Accounts.is_admin?(user)
  end

  def signed_in?(conn) do
    case conn.assigns.current_user do
      nil ->
        false
      %ANV.Accounts.User{} ->
        true
    end

    # or:
    #
    # (conn.assigns.current_user || false) && true
    #
    # (%{} || false) && true  => true
    # (%{} || false) && false => false
    # (nil || false) && true  => false
  end
end
