# Not in  use at the  moment; all the info  needed for
# admins is already in `User`.

  # defmodule ANV.Accounts.Admin do
  #   use Ecto.Schema
  #   import Ecto.Changeset

  #   schema "admins" do
  #     field :username,      :string
  #     field :password,      :string, virtual: true
  #     field :password_hash, :string

  #     timestamps()
  #   end

  #   def changeset(admin, attrs) do
  #     admin
  #     |> ANV.Accounts.User.registration_changeset(attrs, [passwd_min_length: 16])
  #     |> cast(attrs, [:res_dev_id])
  #   end
  # end
