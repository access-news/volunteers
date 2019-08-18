defmodule ANV.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  # NOTE 2019-08-17_1835 On moving to UUIDs and exposing primary keys
  def change do
    create table(:users) do
      add :username,      :string, null: false
      add :password_hash, :string

      # Could've  gone  with  other  solutions,  but  always
      # wanted to try out JSON in PostgreSQL.
      add :roles, :map, null: false

      # {
      #   "role"      : "volunteer",
      #   "source_id" : id  # res_dev
      # },
      # {
      #   "role"      : "admin",
      #   "source_id" : id  # slate
      # }

      timestamps()
    end

    create unique_index(:users, [:username])
    # TODO 2019-08-08_1109
    # create unique index for `source_id` in jsonb
  end
end
