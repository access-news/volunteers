defmodule ANV.Accounts.DataSource do

  use ANV.Schema
  import Ecto.Changeset

  schema "data_sources" do

    field :source, :string
    field :source_id, :string

    belongs_to :user, ANV.Accounts.User

    timestamps()
  end

  def changeset(
    %__MODULE__{} = data_source,
    %{} = attrs
  ) do

    fields = [ :source, :source_id ]

    data_source
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_inclusion(:source, sources())
  end

  def sources() do
    ~w(none slate res_dev)
  end
end
