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
      Readables.change_ad_submission(
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

    # delete `-small.jpg` images
    delete_small_images(id)

    # deletes full resolution images that were uploaded
    Readables.delete_ad!(id)

    redirect(conn, to: Routes.ads_path(conn, :index))
  end

  def delete_small_images(id) do
    id
    |> Readables.get_ad!()
    |> Map.get(:sections)
    |> Enum.each(
      fn %{ path: path } ->
        path
        |> Utility.make_smalljpg_path()
        |> File.rm!()
      end
    )
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

  def update(
    conn,
    %{
      "id" => id,
      "ad" => %{
        "store_name" => store_name,
        "valid_from" => valid_from,
        "valid_to"   => valid_to,
        # "ad_images"  => uploaded_images,
      } = ad_input,
    }
  ) do

#     IO.puts("\n\n")
#     IO.inspect(params)
#     IO.puts("\n\n")

    { date_tuples, dates_map } =
      convert_input_dates(valid_from, valid_to)

    update =
      Map.merge(
        dates_map,
        %{
          sections: process_sections(ad_input),
        }
      )

    # delete `-small.jpg` images
    delete_small_images(id)

    # deletes previous full resolution images,
    # and add update
    case Readables.update_ad(id, update) do

      {:ok, ad} ->

        # NOTE 2019-08-16_1142 On the ImageMagick `Task`s

        make_small_images(ad)
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

        render(conn, "edit.html", changeset: new_changeset)
    end
  end

  # REFACTOR ONLY WHEN THERE ARE TESTS
  def create(
    conn,
    %{
      "ad" => %{
        "store_name" => store_name,
        "valid_from" => valid_from,
        "valid_to"   => valid_to,
        # "ad_images"  => uploaded_images,
      } = ad_input
    }
  ) do

    # TODO 2019-08-13_0951 How to handle reserved ads on update
    # TODO: track upload progress
    # NOTE 2019-08-14_1556 (reason for all the date stuff)

    case Readables.get_ad_by(store_name: store_name) do

      %{ store_name: store_name } ->
        conn
        |> put_flash(:error, "\"#{store_name}\" already taken")
        |> redirect(to: Routes.ads_path(conn, :new))

      nil ->

        # NOTE 2019-08-15_0645 ditch eex and changesets validation
        { date_tuples, dates_map } =
          convert_input_dates(valid_from, valid_to)

        new_ad =
          Map.merge(
            dates_map,
            %{
              sections:   process_sections(ad_input),
              store_name: store_name,
            }
          )

        case Readables.add_store(new_ad) do

          {:ok, ad} ->

            # NOTE 2019-08-16_1142 On the ImageMagick `Task`s

            make_small_images(ad)
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
  end

  defp convert_input_dates(valid_from, valid_to) do
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
  end

  defp process_sections(ad_input) do
    # Have there been any images uploaded?
    case Map.get(ad_input, "ad_images", []) do

      # yes, process them
      uploaded_images when is_list(uploaded_images) ->

        Readables.Ads.process(
          uploaded_images,
          with: &parse_upload/1
        )

      # No,  just   return  an   empty  list
      # (that's what `process/2` above would
      # do anyway.
      [] -> []
    end

  end

  defp make_small_images(ad) do
    for %{ path: path } <- ad.sections do
      Task.start(
        fn ->
          System.cmd(
            "magick",
            [ "convert",
              path,
              "-quality",
              "7",
              Utility.make_smalljpg_path(path)
            ]
          )
        end
      )
    end
  end

  # See `Readables.Ads.process/2` on what the parser
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
