defmodule ANV.Repo.Migrations.CreatePublicationFrequencies do

  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Publication,
    PublicationFrequency,
    PublicationFrequencyJunction,
  }

  @table_name R.table_name(PublicationFrequency).atom

  def change do

    create table(@table_name, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :frequency, :string, null: false
      timestamps()
    end

    create unique_index(@table_name, [:frequency])
  end
end
