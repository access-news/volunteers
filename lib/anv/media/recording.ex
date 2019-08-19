defmodule ANV.Media.Recording do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "recordings" do
    field :recorded_at, :utc_datetime

    belongs_to :user, ANV.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(recording, attrs) do
    recording
    |> change()
    # |> cast(attrs, [:recorded_at])
    # |> validate_required([:recorded_at])
  end
end
