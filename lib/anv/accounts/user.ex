defmodule ANV.Accounts.User do

  use Ecto.Schema
  import Ecto.Changeset
  alias ANV.Accounts.{
    Credential,
    DataSource,
    AccessNewsRole,
  }
  alias ANV.Media.Recording

  # NOTE 20190828_1639 `Credential`

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do

    embeds_many :roles, Roles do
      field :role, :string
    end

    has_many :recordings,   Recording
    has_many :data_sources, DataSource

    has_one :credential, Credential

    timestamps()
  end

  def changeset(
    %__MODULE__{} = user,
    %{} = attrs
  ) do

    user
    |> cast(attrs, [])
    |> cast_embed(
         :roles,
         with: &roles_changeset/2,
         required: true
       )
    |> cast_assoc(:credential, required: true)
    # # NOTE 20190828_1438 `data_source` not mandatory
    |> cast_assoc(:data_sources)
    # # TODO: recording
  end

  defp roles_changeset(
    %__MODULE__.Roles{} = roles,
    %{} = attrs
  ) do

    fields = [ :role ]

    roles
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_inclusion(
         :role,
         ~w(admin volunteer subscriber)
       )
  end
end
