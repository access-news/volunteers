defmodule ANV.Repo.Migrations.CreatePublicationsTypesJunction do

  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Publication,
    PublicationType,
    PublicationTypeJunction
  }

  @table_name R.table_name(PublicationTypeJunction).atom

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
        :publication_type_id,
        references(
          R.table_name(PublicationType).atom,
          on_delete: :delete_all,
          type: :uuid
        ),
        null: false
      )

      timestamps()
    end

    create unique_index(
      @table_name,
      [:publication_id, :publication_type_id]
    )
  end
end
