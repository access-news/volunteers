defmodule ANV.Core.PublicationFrequency do

  use Ecto.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Publication,
    PublicationFrequencyJunction,
  }

  @table_name R.table_name(__MODULE__).string
  @primary_key {:id, :binary_id, autogenerate: true}

  schema @table_name do

    field :frequency, :string

    many_to_many(
      R.table_name(Publication).atom,
      Publication,
      join_through: PublicationFrequencyJunction
    )

    timestamps()
  end
end
