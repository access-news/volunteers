defmodule ANV.Core.Topic do

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Article              \
  , ArticleTopicJunction \
  }

  @table_name R.table_name(__MODULE__).string

  schema @table_name do

    field :topic, :string

    many_to_many(
      R.table_name(Article).atom,
      Article,
      join_through: ArticleTopicJunction
    )

    timestamps()
  end
end
