defmodule ANV.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  # NOTE 2019-08-17_1835 On moving to UUIDs and exposing primary keys

  def change do

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :username, :string, null: false
      timestamps()
    end

    create unique_index(
      :users,
      [:username],
      name: :users_username_index
    )
  end
end
