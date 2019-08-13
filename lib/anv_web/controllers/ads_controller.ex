defmodule ANVWeb.AdsController do
  use ANVWeb, :controller

  alias ANV.Readables

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do

    # Set date pickers to current date
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

  def create( conn,
    %{
      "ad" => %{
        "store_id"   => store_id,
        "store_name" => store_name,
        "valid_from" => valid_from,
        "valid_to"   => valid_to,
        "ad_images"  => uploaded_images,
      }
    }
  ) do

    # TODO 2019-08-13_0951

    sections =
      Readables.Ads.massage(
        uploaded_images,
        with: &parse_upload/1
      )

    new_ad = %{
      store_id:   store_id,
      store_name: store_name,
      valid_from: map_to_date(valid_from),
      valid_to:   map_to_date(valid_to),
      sections:   sections
    }

    Readables.add_store(new_ad)
  end

  defp parse_upload(
    %Plug.Upload{
      content_type: content_type,
      filename:     filename,
      path:         path
    }
  ) do
    %{
      # Uploaded      files      should      conform      to
      # /\d+\.(jpg|png|etc.)/ where the  number is ideally a
      # sequential number represting the page/section of the
      # flyer
      section_id:   Path.rootname(filename),
      # path:         nil,
      src_path:     Path.join(path, filename),
      # reserved:     false,
      content_type: content_type,
    }
  end


  # TODO: Will blow up on wrong date
  defp map_to_date(
    %{"day" => day, "month" => month, "year" => year}
  ) do
    [year, month, day]
    |> Enum.map( &(&1 |> Integer.parse() |> elem(0)) )
    |> List.to_tuple()
    |> Date.from_erl!()
  end

end
