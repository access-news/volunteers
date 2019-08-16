defmodule ANVWeb.Utility do

  def make_smalljpg_path(path) do
    Path.rootname(path) <> "-small.jpg"
  end
end
