defmodule ANV.Core.Issue do

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Publication    \
  , Article        \
  }

  @table_name R.table_name(__MODULE__).string

  schema @table_name do

    field :name, :string
    field :published_at, :date

    belongs_to(
      R.table_name(Publication).atom,
      Publication
    )

    has_many(
      R.table_name(Article).atom,
      Article
    )

    timestamps()
  end
end
