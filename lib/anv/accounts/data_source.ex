defmodule ANV.Accounts.DataSource do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

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
    |> validate_inclusion(:source, sources())
  end

  def sources() do
    ~w(slate res_dev)
  end
end
