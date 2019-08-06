defmodule ANV.Articles.State do
  use Agent

  @ads_json_location   "_ads/ads.json"

  # TODO 2019-08-02_1645
  # All state will be lost  on server restart, so set up
  # a strategy to regulary save in file or DB.
  def start_link(_arg) do
    Agent.start_link(
      fn ->
        read_ads()
      end,
      name: __MODULE__
    )
  end

  def read_json(path) do
    path
    |> File.read!()
    |> Jason.decode!()
  end

  def read_ads() do
    @ads_json_location
    |> read_json()
  end

  def write_json(map, path) do
    map
    |> Jason.encode!()
    |> Jason.Formatter.pretty_print()
    |> (&File.write(path, &1)).()
  end

  def write_ads(map) do
    write_json(map, @ads_json_location)
  end

end
