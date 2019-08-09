defmodule ANVWeb.PageController do
  use ANVWeb, :controller

  def index(conn, _params) do

    # ads  = ANV.Articles.load_ads()
    user = conn.assigns.current_user

    render(
      conn,
      "index.html",
      # ads: ads,
      user: user
    )
  end

  def reserve(conn, params) do
    require IEx; IEx.pry
  end
end
