defmodule ANV.Repo.Migrations.CreateDataSources do
  use Ecto.Migration

  @type_name "sftb_source"
  @table_name :data_sources

  def change do

    execute(
      """
      CREATE TYPE #{@type_name}
        AS ENUM (#{sources_sql_string()})
      """,
      "DROP TYPE #{@type_name}"
    )

    create table(@table_name, primary_key: false) do

      add :id, :uuid, primary_key: true

      add :source,    :"#{@type_name}", null: false
      add :source_id, :string,          null: false

      add(
        :user_id,
        references(
          :users,
          on_delete: :delete_all,
          type:      :uuid
        ),
        null: false # NOTE 2019-08-31_0513
      )

      timestamps()
    end
  end

  defp sources_sql_string() do
    ANV.Accounts.DataSource.sources()
    |> Enum.map(fn source -> "'#{source}'" end)
    |> Enum.join(",")
  end
end
