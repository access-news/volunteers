defmodule ANV.Media do

  alias ANV.Storage
  # NOTE 2019-08-17_0756 why the media context?

  def save(
    path,
    # TODO 2019-08-19_1409 Chromium mp3 content type bug
    [ {:as, name}, {:content_type, content_type} | opts_rest ]
  ) do

    metadata =
      opts_rest
      |> Enum.into(%{})
      |> Map.merge(
          %{
            name: name,
            contentType: content_type
          }
        )

    Storage.upload(
      path,
      metadata
    )
  end

  def delete(name) do
    Storage.delete(name)
  end
end
