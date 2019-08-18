defmodule ANV.Repo.Migrations.CreateRecordings do
  use Ecto.Migration

  def change do
    create table(:recordings) do
      add :recorded_at, :utc_datetime

      # Keep recordings on user deletion. Volunteers produce
      # them  for the  community, and  also, it  is unlikely
      # that users will be deleted.
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:recordings, [:user_id])
  end
end
