defmodule ANV.Core.Topic do

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Article    \
  }

  @table_name R.table_name(__MODULE__).string

  schema @table_name do

    field :name, :string
    field :publication_date, :date

    belongs_to(
      R.table_name(Article).atom,
      Issue
    )

    timestamps()
  end
end
