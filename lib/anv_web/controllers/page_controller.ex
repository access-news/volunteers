defmodule ANVWeb.PageController do
  use ANVWeb, :controller

  def index(conn, _params) do
    ads = ANV.Ads.load_ads()
    render(conn, "index.html", ads: ads)
  end

  def reserve(conn, params) do
    require IEx; IEx.pry
  end
end
