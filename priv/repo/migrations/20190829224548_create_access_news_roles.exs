defmodule ANV.Repo.Migrations.CreateAccessNewsRoles do
  use Ecto.Migration

  # TODO 2019-08-31_0857 seed with available roles

  @type_name "access_news_role"
  @table_name \
    @type_name <> "s"
    |> String.to_atom

  def change do

    execute(
      """
      CREATE TYPE #{@type_name}
        AS ENUM (#{sql_roles_string()})
      """,
      "DROP TYPE #{@type_name}"
    )

    create table(@table_name, primary_key: false) do

      add :id, :uuid, primary_key: true

      add :role, :"#{@type_name}", null: false

      timestamps()
    end
  end

  defp sql_roles_string() do
    ANV.Accounts.AccessNewsRole.roles()
    |> Enum.map(fn role -> "'#{role}'" end)
    |> Enum.join(",")
  end
end
