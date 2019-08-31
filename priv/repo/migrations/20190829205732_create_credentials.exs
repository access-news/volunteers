defmodule ANV.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do

    create table(:credentials, primary_key: false) do

      add :id, :uuid, primary_key: true

      add :username,      :string, null: false
      add :password_hash, :string, null: false

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

    create unique_index(:credentials, [:username])
  end
end
