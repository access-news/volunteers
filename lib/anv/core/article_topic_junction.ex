defmodule ANV.Core.ArticleTopicJunction do

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Article \
  , Topic   \
  }

  @table_name R.table_name(__MODULE__).string
  @primary_key false

  schema @table_name do

    belongs_to :article, Article
    belongs_to :topic,   Topic

    timestamps()
  end

  # see TODO 2019-09-25_0954
end
