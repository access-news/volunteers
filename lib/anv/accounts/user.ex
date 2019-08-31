defmodule ANV.Accounts.User do

  use Ecto.Schema
  import Ecto.Changeset
  alias ANV.Accounts.{
    Credential,
    DataSource,
    AccessNewsRole,
    UserRole,
  }
  alias ANV.Media.Recording

  # NOTE 20190828_1639 `Credential`

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do

    field :username, :string

    many_to_many :roles, AccessNewsRole, join_through: UserRole

    has_many :recordings,   Recording
    has_many :data_sources, DataSource

    has_one :credential, Credential

    timestamps()
  end

  def changeset(
    %__MODULE__{} = user,
    %{} = attrs
  ) do

    fields = [ :username ]

    user
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_length(:username, max: 27)
    |> unique_constraint(:username)

    |> cast_assoc(:credential, required: true)
    # # NOTE 20190828_1438 `data_source` not mandatory
    |> cast_assoc(:data_sources)
    # # TODO: recording
  end
end
