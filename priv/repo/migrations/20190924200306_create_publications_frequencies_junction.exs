defmodule ANV.Repo.Migrations.CreatePublicationsFrequenciesJunction do
  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Publication,
    PublicationFrequency,
    PublicationFrequencyJunction
  }

  @table_name R.table_name(PublicationFrequencyJunction).atom

  def change do

    create table(@table_name, primary_key: false) do

      add(
        :publication_id,
        references(
          R.table_name(Publication).atom,
          on_delete: :delete_all,
          type: :uuid
        ),
        null: false
      )

      add(
        :publication_frequency_id,
        references(
          R.table_name(PublicationFrequency).atom,
          on_delete: :delete_all,
          type: :uuid
        ),
        null: false
      )

      timestamps()
    end

    create unique_index(
      @table_name,
      [:publication_id, :publication_frequency_id]
    )
  end
end
