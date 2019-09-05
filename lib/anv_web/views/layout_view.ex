defmodule ANVWeb.LayoutView do
  use ANVWeb, :view

  def user(conn) do
    conn.assigns.current_user
  end

  def username(conn) do
    user(conn).username

    # user && user.username || ""

    # nil   && _user    || "" => ""
    # %..{} && username || "" => username
  end

  def is_admin?(conn) do
    conn
    |> user()
    |> ANV.Accounts.is_admin?()
  end
end
