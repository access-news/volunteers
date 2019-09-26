defmodule ANV.Repo.Migrations.CreateUsersRolesJunction do
  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Accounts.{
    UserRoleJunction,
    AccessNewsRole
  }

  @table_name R.table_name(UserRoleJunction).atom

  def change do
    # NOTE 2019-09-24_0801
    # The extra `id` column  is superfluous for a junction
    # table, but it keeps  things simple with Phoenix. See
    # also
    # https://softwareengineering.stackexchange.com/questions/182103
    #
    # UPDATE: just removed it. Will see what happens.
    create table(@table_name, primary_key: false) do

      # add :id, :uuid, primary_key: true

      add(
        :user_id,
        references(
          :users,
          # When a user is deleted, cull this
          # junction table of their entries.
          on_delete: :delete_all,
          type:      :uuid
        ),
        null: false # NOTE 2019-08-31_0513
      )

      add(
        :access_news_role_id,
        references(
          R.table_name(AccessNewsRole).atom,
          # When a role is deleted, remove all the
          # rows referencing it.
          on_delete: :delete_all,
          type:      :uuid
        ),
        null: false # NOTE 2019-08-31_0513
      )

      timestamps()
    end

    create unique_index(
      @table_name,
      [:user_id, :access_news_role_id] #,
      # TODO see 2019-09-25_0927
      # name: :users_roles_junction_user_id_access_news_role_id_index
    )
  end
end
