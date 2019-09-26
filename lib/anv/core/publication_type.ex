defmodule ANV.Core.PublicationType do

  use Ecto.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Publication,
    PublicationTypeJunction,
  }

  @table_name R.table_name(__MODULE__).string

  @primary_key {:id, :binary_id, autogenerate: true}

  schema @table_name do

    field :type, :string

    many_to_many(
      R.table_name(Publication).atom,
      Publication,
      join_through: PublicationTypeJunction
    )

    timestamps()
  end
end
