defmodule ANV.Repo.Migrations.CreatePublicationTypes do

  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.PublicationType

  @table_name R.table_name(PublicationType).atom

  def change do

    create table(@table_name, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string, null: false
      timestamps()
    end

    create unique_index(@table_name, [:type])
  end
end
