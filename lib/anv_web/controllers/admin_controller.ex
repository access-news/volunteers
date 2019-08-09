defmodule ANVWeb.AdminController do
  use ANVWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
