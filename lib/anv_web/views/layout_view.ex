defmodule ANVWeb.LayoutView do
  use ANVWeb, :view

  def username(conn) do
    user = conn.assigns.current_user
    user && user.username || ""

    # nil   && _user    || "" => ""
    # %..{} && username || "" => username
  end
end
