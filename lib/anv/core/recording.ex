defmodule ANV.Core.Recording do

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.Article
  alias ANV.Accounts.User

  @table_name R.table_name(__MODULE__).string

  schema @table_name do

    field :recorded_at, :utc_datetime

    belongs_to(
      R.table_name(Article).atom,
      Article
    )

    belongs_to :user, User

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
