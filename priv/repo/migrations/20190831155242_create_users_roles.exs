defmodule ANV.Repo.Migrations.CreateUsersRoles do
  use Ecto.Migration

  @table_name \
    ANV.Accounts.UserRole.table_name()
    |> String.to_atom()

  def change do
    # create table(@table_name, primary_key: false) do

    #   add :id, :uuid, primary_key: true
    create table(@table_name) do

      add(
        :user_id,
        references(
          :users,
          on_delete: :delete_all,
          type:      :uuid
        ),
        null: false # NOTE 2019-08-31_0513
      )

      add(
        :access_news_role_id,
        references(
          :access_news_roles,
          on_delete: :delete_all,
          type:      :uuid
        ),
        null: false # NOTE 2019-08-31_0513
      )

      timestamps()
    end

    create unique_index(@table_name, [:user_id, :access_news_role_id])
  end
end
