defmodule ANV.Accounts.AccessNewsRole do

  use Ecto.Schema
  import Ecto.Changeset

  alias ANV.Accounts.{
    UserRoleJunction,
    User
  }

  @table_name "access_news_roles"

  @primary_key {:id, :binary_id, autogenerate: true}

  schema @table_name do

    field :role, :string

    many_to_many :users, User, join_through: UserRoleJunction

    timestamps()
  end

  def changeset(
    %__MODULE__{} = role,
    %{} = attrs
  ) do

    fields = [ :role ]

    # TODO add unique validation when removing enum
    # see 2019-09-25_0927 also while at it
    role
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_inclusion(:role, roles())
  end

  def roles() do
    ~w(admin subscriber volunteer)
  end

  def table_atom() do
    @table_name |> String.to_atom()
  end
end
