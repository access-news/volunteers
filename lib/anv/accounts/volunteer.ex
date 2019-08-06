defmodule ANV.Accounts.Volunteer do
  use Ecto.Schema
  import Ecto.Changeset

  # see TODO 2019-08-06_1003
  schema "volunteers" do
    field :username,      :string
    field :password,      :string, virtual: true
    field :password_hash, :string
    field :res_dev_id,    :string

    timestamps()
  end

  def changeset(volunteer, attrs) do
    volunteer
    |> ANV.Accounts.User.registration_changeset(attrs, [passwd_min_length: 7])
    |> cast(attrs, [:res_dev_id])
    |> validate_required([:res_dev_id])
  end
end
