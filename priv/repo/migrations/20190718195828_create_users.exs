defmodule ANV.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  # see TODO 2019-08-06_1003

  def change do
    create table(:users) do
      add :username,      :string, null: false
      add :password_hash, :string
      # add :res_dev_id,    :string
      add :roles,         :map,    null: false

      # {
      #   "volunteer": {
      #     "res_dev_id" : id
      #   },
      #   "admin": true
      # }

      timestamps()
    end

    create unique_index(:users, [:username  ])
    create unique_index(:users, [:res_dev_id])
  end
end
