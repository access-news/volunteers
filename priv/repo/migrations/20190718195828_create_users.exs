defmodule ANV.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username,      :string, null: false
      add :password_hash, :string

      # Could've  gone  with  other  solutions,  but  always
      # wanted to try out JSON in PostgreSQL.
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
    # TODO: create index for res_dev_id in jsonb
    # create unique_index(:users, [:res_dev_id])
  end
end
