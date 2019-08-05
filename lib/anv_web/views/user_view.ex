defmodule ANVWeb.UserView do
  use ANVWeb, :view

  alias ANV.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
