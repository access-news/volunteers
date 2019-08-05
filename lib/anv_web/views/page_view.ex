defmodule ANVWeb.PageView do
  use ANVWeb, :view

  def src_small(src_path) do
    src_path
    |> Path.rootname()
    |> (&<>/2).("-small.jpg")
  end

  def reserved?(meta, page_number) do
    page_number in meta["reserved_pages"]
  end
end
