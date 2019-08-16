defmodule ANV.Readables.Ads do

  # alias ANV.Ads.State
  alias ANV.Readables
  alias __MODULE__.Ad

  @ads_in_dir          "_ads/input"
  @img_src_attr_prefix "/images/"
  @ads_out_dir  \
    "priv/static"
    |> Path.join(@img_src_attr_prefix)
    |> Path.expand()

  # TODO 2019-08-02_1646
  # Implement  the  warning  when  the  close  proximity
  # reserves happens.  ("We are  sorry, but  someone was
  # faster at the draw.")
  #
  # see also TODO 2019-08-02_1645
  #
  # QUESTION: How can it be tested?

  # TODO 2019-08-02_1647
  # Expire  reserve  if no  upload  in  2 hours.  Sounds
  # reasonable I guess. Make it  dependent  on priority.

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

  def update_reserved_pages(ads, store_id, page_number) do

    Map.update!(
      ads,
      store_id,
      fn store_map ->

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

  # Only  deleting images  that  will be  updated.
  def delete_section_images(ad) do

    Enum.each(
      ad.sections,
      fn %{ path: path } ->

        # delete full res image
        File.rm!(path)
      end
    )

    ad
  end

  @doc """
  Handles  the saving  of  the  submitted store  flyer
  sections (i.e., a list as its first argument),  with
  a supplied  `section_parser/1` that will be  used to
  process  the  individual  sections  list  items.  It
  should return a map with 3 keys:

  ```elixir
  %{
    section_id:   # sequential numbers  denoting the  order of
                  # the submitted  store flyer  section images
                  # (e.g., if each image  is one page then the
                  # `section_id` will be the page number)

    src_path:     # The  location  of  the  submitted  images.
                  # For  example, uploading  via Phoenix  will
                  # produce    `Phoenix.Upload`  struct   that
                  # contains  the   temporary  path    of  the
                  # uploaded images.

    content_type: # The MIME type of the submitted image.
  }
  ```
  """
  def process(submitted_sections, with: section_parser) do

    # TODO: validate file type
    # This  should  probably  be  done  here  and  on  the
    # frontend as well. Here, to handle errors gracefully,
    # if the  frontend didn't  manage to catch  wrong file
    # types. (And this would be  part of the API, so maybe
    # it  is  called  from  somewhere  other  than  a  web
    # frontend.)              |
                          #   |
    Enum.map(             #   | ?
      submitted_sections, #   /
      fn submission ->    #  /
        submission        # L
        |> section_parser.()
        |> generate_new_filenames()
        |> persist_images()
        |> do_section()
      end
    )
  end

  defp generate_new_filenames(
    %{ content_type: content_type } = map
  ) do

    extname = content_type |> String.split("/") |> List.last()

    destination_path =
      Enum.join([
        Path.join( @ads_out_dir, Ecto.UUID.generate() ),
        ".",
        extname
      ])

    Map.put(map, :path, destination_path)
  end

  defp persist_images(
    %{
      path:     destination_path,
      src_path: src_path
    } = map
  ) do

    File.cp!(src_path, destination_path)

    map
  end

  @doc """
  Could've   used   map  transformations   to   remove
  `src_path`  and add  `reserved` but  this way  it is
  explicit (even if longer).
  """
  defp do_section(
    %{
      section_id:   section_id,
      path:         destination_path,
      content_type: content_type,
    }
  ) do
    %{
      section_id:   section_id,
      path:         destination_path,
      reserved:     false,
      content_type: content_type,
    }
  end
end
