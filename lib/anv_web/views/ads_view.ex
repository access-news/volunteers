defmodule ANVWeb.AdsView do
  use ANVWeb, :view

  def custom_datetime_select(form, field, opts \\ []) do
    builder = fn b ->
      ~e"""
      <%= b.(:month, []) %>
      <%= b.(:day,   []) %>
      <%= b.(:year,  []) %>
      """
    end

    datetime_select(form, field, [builder: builder] ++ opts)
  end

  def make_smalljpg_static_path(path) do
    path
    |> String.split("static")
    |> List.last()
    |> Utility.make_smalljpg_path()
  end
end
