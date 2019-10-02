defmodule ANV.Core.Article do

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Issue    \
  }

  @table_name R.table_name(__MODULE__).string

  schema @table_name do

    field :title, :string
    field :publication_date, :date

    belongs_to(
      R.table_name(Issue).atom,
      Issue
    )

    timestamps()
  end
end
