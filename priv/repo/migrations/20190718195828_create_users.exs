defmodule ANV.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :password_hash, :string
      # TODO: what is their ID format?
      # TODO: make this the primary id
      add :res_dev_id, :string

      timestamps()
    end

    create unique_index(:users, [:username  ])
    create unique_index(:users, [:res_dev_id])
  end
end
