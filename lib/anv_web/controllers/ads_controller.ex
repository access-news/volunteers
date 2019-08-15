defmodule ANVWeb.AdsController do
  use ANVWeb, :controller

  alias ANV.Readables

  def index(conn, _params) do
    ads = Readables.list_ads()
    render(conn, "index.html", ads: ads)
  end

  def new(conn, _params) do

    # NOTE 2019-08-15_0645 ditch eex and changesets validation
    # Set date pickers to current date
    valid_from = valid_to =
      Date.utc_today()
      |> Date.to_erl()

    changeset =
      ANV.Readables.change_ad_submission(
        %{
          valid_from: valid_from,
          valid_to:   valid_to,
        }
      )

    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{ "id" => id }) do
    ad = Readables.get_ad!(id)
    render(conn, "show.html", sections: ad.sections)
  end

  def delete(conn, %{ "id" => id }) do
    Readables.delete_ad!(id)
    redirect(conn, to: Routes.ads_path(conn, :index))
  end

  def edit(conn, %{ "id" => id }) do
    ad = Readables.get_ad!(id)

    # NOTE 2019-08-15_0645 ditch eex and changesets validation
    changeset =
      Ecto.Changeset.change(
        ad,
        %{
          valid_from: ad.valid_from |> Date.to_erl(),
          valid_to:   ad.valid_to   |> Date.to_erl()
        }
      )

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{ "id" => id }) do
  end

  # REFACTOR ONLY WHEN THERE ARE TESTS
  def create( conn,
    %{
      "ad" => %{
        "store_id"   => store_id,
        "store_name" => store_name,
        "valid_from" => valid_from,
        "valid_to"   => valid_to,
        # "ad_images"  => uploaded_images,
      } = new_ad
    }
  ) do

    # TODO 2019-08-13_0951 How to handle reserved ads on update

    can_add_store? =
      Readables.add_store(
        %{
          store_id:   store_id,
          store_name: store_name
        }
      )

    # NOTE 2019-08-14_1556 (reason for all the date stuff)
    { date_tuples, dates_map } =
      Enum.reduce(
        %{
          valid_from: valid_from,
          valid_to:   valid_to
        },
        { %{}, %{} },
        fn { key, input_date }, { t, m } ->

          date_tuple = map_to_date_tuple(input_date)

          new_t = Map.put(t, key, date_tuple)

          new_m =
            Map.put(
              m,
              key,
              Date.from_erl!(date_tuple)
            )

          { new_t, new_m }
        end
      )

    case can_add_store? do

      {:ok, ad} ->

        sections =
          Readables.Ads.massage(
            # if no images uploaded, just process an empty list
            Map.get(new_ad, "ad_images", []),
            with: &parse_upload/1
          )

        update =
          Map.merge(
            dates_map,
            %{ sections: sections }
          )

        # TODO: deal with an error
        # TODO: track upload progress
        Readables.update_ad(ad, update)

        redirect(conn, to: Routes.ads_path(conn, :index))

      {:error, changeset} ->

        # NOTE 2019-08-15_0645 ditch eex and changesets validation
        new_changeset =
          Ecto.Changeset.change(
            changeset,
            %{
              valid_from: date_tuples.valid_from,
              valid_to:   date_tuples.valid_to,
            }
          )

        render(conn, "new.html", changeset: new_changeset)
    end
  end

  # See `ANV.Readables.Ads.massage/2` on what the parser
  # should conform to.
  defp parse_upload(
    %Plug.Upload{
      content_type: content_type,
      filename:     filename,
      path:         path
    }
  ) do
    # Uploaded      files      should      conform      to
    # /\d+\.(jpg|png|etc.)/ where the  number is ideally a
    # sequential number represting the page/section of the
    # flyer
    section_id = Path.rootname(filename)

    %{
      section_id:   section_id,
      src_path:     path,
      content_type: content_type,
    }
  end

  # TODO: Will blow up on wrong date
  defp map_to_date_tuple(
    %{"day" => day, "month" => month, "year" => year}
  ) do
    [year, month, day]
    |> Enum.map( &(&1 |> Integer.parse() |> elem(0)) )
    |> List.to_tuple()
  end

end
