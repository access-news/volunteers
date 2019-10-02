defmodule ANV.Repo.Migrations.CreateArticles do

  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Issue   \
  , Article \
  }

  @table_name R.table_name(Article).atom

  def change do

    create table(@table_name, primary_key: false) do

      add :id, :uuid, primary_key: true
      add :title,        :string, null: false
      add :published_at, :date,   null: false
      add :valid_until,  :date

      add(
        :issue_id,
        references(
          R.table_name(Issue).atom,
          on_delete: :delete_all,
          type:      :uuid
        ),
        null: false
      )

      timestamps()
    end

    # TODO unique index on (title, author, published_at)
    # create unique_index(@table_name, [:name, :published_at])
  end
end
