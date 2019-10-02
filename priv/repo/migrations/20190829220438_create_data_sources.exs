defmodule ANV.Repo.Migrations.CreateDataSources do
  use Ecto.Migration

  # See notes 2019-10-01_0942 and 2019-10-01_0944 first
  # VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  # TODO see 2019-09-24_1119 replace ENUM with seeds
  # TODO see 2019-08-31_0857 seed with available roles
  # TODO add unique index to role when removing ENUM type

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

      # NOTE 2019-10-01_0944 should this be a separate table instead?
      # Or  that  may  be  an  overkill.  See  related  note
      # 2019-10-01-0942, but  the gist is, learn  more about
      # queries.
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
