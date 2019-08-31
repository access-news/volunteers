defmodule ANV.Accounts.UserRole do

  use Ecto.Schema
  import Ecto.Changeset

  alias ANV.Accounts.{
    AccessNewsRole,
    User
  }

  @table_name "users_roles"
  @primary_key false

  schema @table_name do

    belongs_to :user, User,           type: :binary_id
    belongs_to :access_news_role, AccessNewsRole, type: :binary_id

    timestamps()
  end

  def changeset(
    %__MODULE__{} = user_role,
    %{} = attrs
  ) do

    fields = [ :user_id, :access_news_role_id ]

    user_role
    |> cast(attrs, fields)
    |> validate_required(fields)
  end

  def table_name() do
    @table_name
  end
end
