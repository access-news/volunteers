defmodule ANV.Accounts.AccessNewsRole do

  use Ecto.Schema
  import Ecto.Changeset

  alias ANV.Accounts.{
    UserRole,
    User
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "access_news_roles" do

    field :role, :string

    many_to_many :users, User, join_through: UserRole

    timestamps()
  end

  def changeset(
    %__MODULE__{} = role,
    %{} = attrs
  ) do

    roles  = roles()
    fields = [ :role ]

    role
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_inclusion(:role, roles)
  end

  def roles() do
    ~w(admin subscriber volunteer)
  end
end
