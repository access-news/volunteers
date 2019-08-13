defmodule ANVWeb.UserView do
  use ANVWeb, :view

  def roles(user) do
    Enum.map(
      user.roles,
      fn %{ role: role, source_id: id } ->
        "#{role} (#{id})"
      end
    )
    |> Enum.join("\n")
  end
end
