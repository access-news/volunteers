defmodule ANV.Core.Recording do

  use ANV.Schema
  import Ecto.Changeset

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
