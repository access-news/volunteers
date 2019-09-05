defmodule ANV.Accounts.PhoneNumber do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  # needed for `belongs_to/3`
  @foreign_key_type :binary_id

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
    # |> check_constraint(
    #      :phone_number,
    #      name: :phone_number_must_be_a_ten_digit_string
    #    )
  end
end
