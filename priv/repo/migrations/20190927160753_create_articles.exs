defmodule ANV.Repo.Migrations.CreateArticles do

  @moduledoc """
  Ads
  ===

  + An issue  corresponds to  a weekly flyer  (hence the
    `:valid_until` field).

  + The  edition is  a geographically  different version
    (but usually they are all the same).

  + An article corresponds to  a specific section in the
    flyer.
  """

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
      add :publication_date, :date,   null: false

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
