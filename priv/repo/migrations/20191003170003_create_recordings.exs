defmodule ANV.Repo.Migrations.CreateRecordings do

  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.Article

  def change do
    create table(:recordings, primary_key: false) do

      add :id, :uuid, primary_key: true
      add :recorded_at, :timestamptz, null: false

      # add :metadata (?)

      add(
        :user_id,
        references(
          :users,
          # Keep recordings on user deletion. Volunteers produce
          # them  for the  community, and  also, it  is unlikely
          # that users will be deleted.

          # TODO: keep track user after user deletion
          #
          #       It  would  be  nice  though  to  know  who
          #       recorded it. Event  sourcing sounds pretty
          #       good in these situations.
          on_delete: :nothing,
          type:      :uuid
        ),
        null: false # NOTE 2019-08-31_0513
      )

      add(
        :article_id,
        references(
          R.table_name(Article).atom,
          # Do nothing for the same reason as with user.
          # TODO: same as with user reference above.
          on_delete: :nothing,
          type:      :uuid
        ),
        null: false # NOTE 2019-08-31_0513
      )

      timestamps()
    end

    create index(:recordings, [:user_id, :article_id])
  end
end
