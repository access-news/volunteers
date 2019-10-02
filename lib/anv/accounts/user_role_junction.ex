defmodule ANV.Accounts.UserRoleJunction do

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Accounts.{
    AccessNewsRole,
    User
  }

  @table_name ANV.Repo.Aid.table_name(__MODULE__).string
  @primary_key false

  schema @table_name do

    belongs_to :user, User
    belongs_to :access_news_role, AccessNewsRole

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
    # TODO see 2019-09-25_0927

    # TODO 2019-09-25_0954 `cast_assoc` for all junction tables
    # also add `required: true` to `cast_assoc` options
  end
end
