defmodule ANVWeb.AdsController do
  use ANVWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do

    valid_from = valid_to =
      Date.utc_today()
      |> Date.to_iso8601()
      |> String.split("-")
      |> Enum.reduce(
          {},
          fn(date_part, acc) ->
            date_part
            |> Integer.parse()
            |> elem(0)
            |> (&Tuple.append(acc,&1)).()
          end
        )

    changeset =
      ANV.Readables.change_ad_submission(
        %{
          valid_from: valid_from,
          valid_to: valid_to,
        }
      )

    render(conn, "new.html", changeset: changeset)
  end

  def create(
    conn,
    params
    # %{
    #   "ad_images"  => images,
    #   "store_id"   => store_id,
    #   "store_name" => store_name,
    #   "valid_from" => valid_from,
    #   "valid_to"   => valid_to,
    # }
  ) do
    require IEx; IEx.pry
  end
end
