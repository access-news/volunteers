defmodule ANV.Repo.Migrations.CreateTopics do

  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.Topic

  @table_name R.table_name(Topic).atom

  def change do

    create table(@table_name, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :topic, :string, null: false
      timestamps()
    end

    create unique_index(@table_name, [:topic])
  end
end
