defmodule ANV.Repo.Migrations.CreateRecordings do
  use Ecto.Migration

  def change do
    create table(:recordings) do
      add :recorded_at, :naive_datetime
      # TODO What to do on user deletion?
      #      Maybe it can be left as it is, because
      #      we keep reader records, even if they quit
      #      (we have to), and listeners never quit,
      #      although it may change.
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:recordings, [:user_id])
  end
end
