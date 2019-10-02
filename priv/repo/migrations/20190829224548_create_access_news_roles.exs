defmodule ANV.Repo.Migrations.CreateAccessNewsRoles do
  use Ecto.Migration

  # TODO 2019-09-24_1119 replace ENUM with seeds
  #
  # The problem with  ENUM is that if values  need to be
  # added later then it  the schemas may become chaotic,
  # and  the  migrations  are also  not  straightforward
  # becuase   values   cannot  be   removed,   therefore
  # rollbacks won't be possible. The best solution is to
  # store a  list in a  textfile, but then why  not just
  # use a table and seed that in the beginning?
  #
  # UPDATE
  #
  # Keep   rediscovering  the   same  things   (such  as
  # `has_many` vs `many_to_many`) so basically I started
  # using ENUMs as a static type checker (good analogy?)
  # that the table  would only hold the  values that are
  # allowed, but  my thinking  is backwards,  because it
  # would only check entries to the SAME table.
  #
  # Also  no  point to  check  the  ENUM values  in  the
  # changeset  because  updates/insert will  go  through
  # associations  (see `seeds.exs`),  so one  will never
  # define a role by name.

  # TODO 2019-08-31_0857 seed with available roles

  @type_name  "access_news_role"
  @table_name ANV.Accounts.AccessNewsRole.table_atom()

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

    # TODO add unique index to role when removing ENUM type
  end

  defp sql_roles_string() do
    ANV.Accounts.AccessNewsRole.roles()
    |> Enum.map(fn role -> "'#{role}'" end)
    |> Enum.join(",")
  end
end
