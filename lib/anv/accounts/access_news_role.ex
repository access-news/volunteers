defmodule ANV.Accounts.AccessNewsRole do

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Accounts.{
    UserRoleJunction,
    User
  }

  @table_name "access_news_roles"

  schema @table_name do

    field :role, :string

    # NOTE 2019-10-01_0942 Overkill?
    # Initially, this was done to  make it easier to query
    # "admins",  for example,  but  becuase  I'm not  very
    # proficient regarding queries,  a simple `has_many/3`
    # may have sufficed.
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

  # This can stay even after removing enum, as an internal check
  def roles() do
    ~w(admin subscriber volunteer)
  end

  def table_atom() do
    @table_name |> String.to_atom()
  end
end
