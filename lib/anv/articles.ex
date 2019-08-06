defmodule ANV.Articles do

  alias ANV.Articles.State

  @ads_in_dir          "_ads/input"
  @img_src_attr_prefix "/images/ads/"
  @ads_out_dir         Path.join("priv/static", @img_src_attr_prefix)

  # Choosing map  as output to be  able to use it  for a
  # JSON API later

  # HISTORICAL NOTE
  #
  # Originally, this  was just an  Agent with a  list as
  # state, and the state map was  saved to a file on the
  # disk. The purpose  of the agent was  to prevent race
  # conditions  when  multiple  people  reserve  a  page
  # almost at the  same time, but the  storing the state
  # in the file became untenable. The check is the same,
  # albeit a bit more complex, but when starting to save
  # to a DB, this can be simplified again.

  # see TODO 2019-08-02_1645

  # TODO 2019-08-02_1646
  # Implement  the  warning  when  the  close  proximity
  # reserves happens.  ("We are  sorry, but  someone was
  # faster at the draw.")
  #
  # QUESTION: How can it be tested?

  # TODO 2019-08-02_1647
  # Expire reserve if no upload in 2 hours. Sounds reasonable I guess.

  def reserve(store_id, page_number) do

    Agent.get_and_update(
      State,
      fn state ->

        case page_number in state[store_id]["reserved_pages"] do

          true ->
            { {:error, "already_reserved"}, state }

          false ->
            new_state =
              update_reserved_pages(
                state,
                store_id,
                page_number
              )
            { :ok, new_state }
        end
      end
    )
  end

# %{
#   "raleys" => %{
#     "paths" => %{
#       "1" => "/images/ads/60dcd5c9-a56f-4d55-97ee-2bdbbfc9b21e.png",
#       "2" => "/images/ads/c042e789-6bbc-4039-84ac-5c013525faeb.png",
#       "3" => "/images/ads/c0886957-ef6e-426e-9665-4effa858cc30.png",
#       "4" => "/images/ads/4e34d560-eb25-454c-a9fb-f0b7cace6ce2.png",
#       "5" => "/images/ads/5ecc132e-6e74-4459-bd03-23e00b92a08d.png"
#     },
#     "reserved_pages" => [],
#     "status" => "update",
#     "store" => "Raley's, BelAir, and Nob Hill Foods", 
#     "valid" => "July 24 - July 30"
#   },
#   "safeway" => %{
#     "paths" => %{
#       "1" => "/images/ads/60f9764e-51bf-4fe0-a5f6-b5fda681e247.jpg",
#       "2" => "/images/ads/c32ac7e8-3d87-4c2d-95fd-6ef802d196f5.jpg",
#       "3" => "/images/ads/1f54cfa4-07eb-498e-9aee-0897dfd33147.jpg",
#       "4" => "/images/ads/d698fbbd-9e3c-416b-b00b-0193f9cccd1b.jpg",
#       "5" => "/images/ads/536b923e-a791-4fa9-bddd-e621d0592c07.jpg",
#       "6" => "/images/ads/fedda23c-0dbf-491b-8d1d-bcb6eab05820.jpg"
#     },
#     "reserved_pages" => [],
#     "status" => "update",
#     "store" => "Safeway",
#     "valid" => "July 24 - July 30"
#   }
# }

  def update_reserved_pages(ads, store_id, page_number) do

    Map.update!(
      ads,
      store_id,
      fn store_map ->

        # NOTE 2019-08-02_1449
        # No  need for  `Map.update/4`  (that  has an  initial
        # value for when the key  does not exist), because the
        # "reserved_pages" key is added  when a new section is
        # created (in `process_submitted/1`).
        Map.update!(
          store_map,
          "reserved_pages",
          fn reserved_pages ->
            case page_number == :all do
              false ->
                [ page_number | reserved_pages ]
              true ->
                Map.get(store_map, "paths")
                |> Map.keys()
                |> Enum.concat(reserved_pages)
            end
          end
        )
      end
    )
  end

  def load_ads() do
    Agent.get(State, &(&1))
  end

  def save_ads(map) do
    Agent.update(State, fn _state -> map end)
  end

  # submitted = %{ store_id => %{ paths => [], ... }}
  # see `list/0`'s output at the bottom
  def submit_ads(submitted) do

    { ads, update } =
      load_ads()
      |> winnow(submitted)

    save_ads(ads)

    update
  end

  def winnow(ads, submitted) do

    Enum.reduce(
      submitted,
      { ads, %{} },
      fn(
        { store_id, _meta } = ads_entry_tuple,
        { ads, update }
      ) ->

        # Adding status to the  update payload is not strictly
        # necessary (becuase the frontend could figure it out;
        # if no HTML element with `store_id`, then create it),
        # but it doesn't add much overhead and more explicit.
        status =
          case Map.has_key?(ads, store_id) do
            false ->
              "new"
            true  ->
              delete_previous_images(ads[store_id])
              "update"
          end

        new_ads_entry = process_submitted(ads_entry_tuple)

        {
          # update ads.json
          Map.merge(ads, new_ads_entry),

          # update to be sent to frontend
          new_ads_entry
          |> Map.update!(store_id, &Map.put(&1, "status", status))
          |> (&Map.merge(update, &1)).()
        }
      end
    )
  end

  # Only  deleting images  that  will be  updated.
  # `ads.json` will be updated by `process_submitted/2`
  defp delete_previous_images(
    %{ "paths" => paths_with_page_numbers }
  ) do
    Enum.each(
      paths_with_page_numbers,
      fn { _page_number, src_path } ->

        base = Path.basename(src_path) #=> UUID.<img_format>
        root = Path.rootname(base)     #=> UUID

        # delete full res image
        @ads_out_dir
        |> Path.join(base)
        |> File.rm!()

        # delete small version
        @ads_out_dir
        |> Path.join(root)
        |> (&<>/2).("-small.jpg")
        |> File.rm!()
      end
    )
  end

  def process_submitted({ store_id, %{ "paths" => paths } = meta }) do

    new_meta =
      paths                                 #=> [path_1, ..., path-n]
      |> copy_images_and_add_page_numbers() #=> ["1" => src_path, ... ]
      |> (&Map.put(meta, "paths", &1)).()   #=> meta
      # see NOTE 2019-08-02_1449
      |> Map.put("reserved_pages", [])      #=> meta

    %{ store_id => new_meta }
  end

  defp copy_images_and_add_page_numbers(paths) do

    Enum.reduce(
      paths,
      %{},
      # {%{}, %{}},
      fn image_path, acc ->
      # fn image_path, { small, full_res} ->

        new_base_filename = Ecto.UUID.generate()
        orig_extname      = Path.extname(image_path)

        new_filename       = new_base_filename <> orig_extname
        new_filename_small = new_base_filename <> "-small.jpg"

        File.cp!(
          image_path,
          Path.join(@ads_out_dir, new_filename)
        )

        # https://stackoverflow.com/questions/2257322
        System.cmd(
          "magick",
          [ "convert",
            image_path,
            "-quality",
            "7",
            Path.join(@ads_out_dir, new_filename_small)
          ]
        )

        # {
          # Map.put(
          #   small,
          #   page_number,
          #   Path.join(@img_src_attr_prefix, new_filename_small)
          # ),
        Map.put(
          # full_res,
          acc,
          get_page_number(image_path),
          Path.join(@img_src_attr_prefix, new_filename)
        )
        # }
      end)
  end

  defp get_page_number(image_path) do
      image_path
      |> Path.basename()
      |> Path.rootname()
  end

  # --- TEMPORARY ------------------------------------------------------
  #
  # Only here to emulate a frontend form input.

  def list do

    @ads_in_dir
    |> File.ls!()
    |> Enum.reduce(%{}, fn dir, acc ->

          rel_dir = Path.join(@ads_in_dir, dir)
          meta = Path.join(rel_dir, "meta.json") |> State.read_json()

          image_paths =
            File.ls!(rel_dir)
            |> Enum.reduce([], fn file, acc ->
                case file == "meta.json" do
                  true ->
                    acc
                  false ->
                    [ Path.join(rel_dir, file) | acc ]
                end
              end)

          Map.put(
            acc,
            dir,
            Map.put(meta, "paths", image_paths)
          )
        end)

    # %{
    #   "food-source" => %{
    #     "paths" => ["_ads/food-source/1.png", "_ads/food-source/2.png"],
    #     "store" => "Food Source"
    #   },
    #   "foods-co" => %{
    #     "paths" => ["_ads/foods-co/1.png", "_ads/foods-co/2.png"],
    #     "store" => "Food Co"
    #   },
    # }
  end
end
