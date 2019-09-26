defmodule ANV.Accounts.User do

  use Ecto.Schema
  import Ecto.Changeset

  alias ANV.Accounts.{
    Credential,
    DataSource,
    AccessNewsRole,
    UserRoleJunction,
    PhoneNumber
  }
  # alias ANV.Core.Recording

  # NOTE 20190828_1639 `Credential`

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do

    field :username, :string

    many_to_many(
      AccessNewsRole.table_atom(),
      AccessNewsRole,
      join_through: UserRoleJunction
    )

    # has_many :recordings,    Recording
    has_many :data_sources,  DataSource

    # NOTE TODO? 2019-09-23_1410
    # This  should be  `many_to_many`,  but currently  the
    # user, phone number combo  needs to be unique because
    # of TR2's login mechanism. Is there a better way?
    has_many :phone_numbers, PhoneNumber

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

    # TODO: check `unique_constraint`s and make indices explicit
    |> unique_constraint(:username, name: :users_username_index)

    |> cast_assoc(:credential, required: true)
    # NOTE 20190828_1438 `data_source` not mandatory
    |> cast_assoc(:data_sources)
    |> cast_assoc(:phone_numbers)
    # TODO: recording
  end
end
