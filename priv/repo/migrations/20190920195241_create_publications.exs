defmodule ANV.Repo.Migrations.CreatePublications do

  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.Publication

  @table_name R.table_name(Publication).atom

  def change do
    create table(@table_name, primary_key: false) do

      add :id, :uuid, primary_key: true

      add :name, :string, null: false

      # not urgent
      # ==========
      # see https://en.wikipedia.org/wiki/Periodical_literature
      # add :frequency,
      # see https://en.wikipedia.org/wiki/Newspaper#Categories
      # Q: How to make it possible to query by location?
      # add :geographical_scope, [local, regional, domestic,  international]

      timestamps()
    end

    create unique_index(@table_name, [:name])
  end
end
