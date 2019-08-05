defmodule ANV.Media.Recording do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recordings" do
    field :recorded_at, :naive_datetime
    field :user_id, :id

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
