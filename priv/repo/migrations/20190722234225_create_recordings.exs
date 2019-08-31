defmodule ANV.Repo.Migrations.CreateRecordings do
  use Ecto.Migration

  def change do
    create table(:recordings, primary_key: false) do

      add :id, :uuid, primary_key: true

      add :recorded_at, :utc_datetime

      add(
        :user_id,
        references(
          :users,
          # Keep recordings on user deletion. Volunteers produce
          # them  for the  community, and  also, it  is unlikely
          # that users will be deleted.
          on_delete: :nothing,
          type:      :uuid
        ),
        null: false # NOTE 2019-08-31_0513
      )

      timestamps()
    end

    create index(:recordings, [:user_id])
  end
end
