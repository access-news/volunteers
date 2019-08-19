defmodule ANV.Storage do

  alias GoogleApi.Storage.V1.{
    Model,
    Api,
    Connection,
  }

  @read_write_scope "https://www.googleapis.com/auth/devstorage.read_write"
  @read_only_scope  "https://www.googleapis.com/auth/devstorage.read_only"
  @bucket "access-news-recordings"

  defp get_conn(scope) do
    # "The first request for a token will hit the API, but
    # subsequent  requests will  retrieve  the token  from
    # Goth's token store."
    {:ok, t} = Goth.Token.for_scope(scope)

    Connection.new(t.token)
  end

  @doc """
    Metadata fields for the Elixir package:
    https://hexdocs.pm/google_api_storage/GoogleApi.Storage.V1.Model.Object.html

    Description  of  accepted  values by  each  metadata
    field:
    https://cloud.google.com/storage/docs/metadata#content-language

    For example, tried the following,
    ```elixir
    "./notes.md"
    |> Path.expand()
    |> ANV.Media.store(
         as: "hejehuja.md",
         content_type: "text/markdown",
         contentLanguage: "en-EN"
       )
    ```
    but failed, because `contentLanguage`  only  accepts
    ISO 639-1 language codes. (Learned the hard way that
    the  `Object` metadata fields corresponding to  HTTP
    headers do not  necessarily  accepts values that the
    headers do. See [MDN's `Content-Language` article](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Language).
    """
  def upload(
    path,
    metadata_map
  ) do

    metadata =
      Map.merge(
        %Model.Object{},
        metadata_map
      )

    Api.Objects.storage_objects_insert_simple(
      get_conn(@read_write_scope),
      @bucket,
      "multipart",
      metadata,
      path
    )
  end

  def delete(name) do
    Api.Objects.storage_objects_delete(
      get_conn(@read_write_scope),
        @bucket,
        name
        # optional_params \\ [],
        # opts \\ []
      )
  end

  def list_objects() do
    Api.Objects.storage_objects_list(
      get_conn(@read_only_scope),
      @bucket
    )
    |> case do
         {:ok, result} ->
           case result.items do
             nil     -> {:ok, []}
             objects -> {:ok, objects}
           end
         {:error, _} = error ->
           error
       end
  end
end
