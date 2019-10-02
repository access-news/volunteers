defmodule ANV.Accounts.PhoneNumber do

  use ANV.Schema
  import Ecto.Changeset

  schema "phone_numbers" do

    field :phone_number, :string

    belongs_to :user, ANV.Accounts.User

    timestamps()
  end

  def changeset(
    %__MODULE__{} = phone_number,
    %{} = attrs
  ) do

    fields = [ :phone_number ]

    phone_number
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_format(:phone_number, ~r/^\d{10}$/)
  end
end
