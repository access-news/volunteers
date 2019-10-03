defmodule ANV.Repo.Migrations.CreateArticlesTopicsJunction do

  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Article              \
  , Topic                \
  , ArticleTopicJunction \
  }

  @table_name R.table_name(ArticleTopicJunction).atom

  def change do

    create table(@table_name, primary_key: false) do

      add(
        :article_id,
        references(
          R.table_name(Article).atom,
          on_delete: :delete_all,
          type: :uuid
        ),
        null: false
      )

      add(
        :topic_id,
        references(
          R.table_name(Topic).atom,
          on_delete: :delete_all,
          type: :uuid
        ),
        null: false
      )

      timestamps()
    end

    create unique_index(
      @table_name,
      [:article_id, :topic_id]
    )
  end
end
