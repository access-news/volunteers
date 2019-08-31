defmodule ANV.Accounts.Credential do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "credentials" do

    field :password,        :string,  virtual: true
    # admins will have significantly longer passwords
    field :password_length, :integer, virtual: true
    field :password_hash,   :string

    belongs_to :user, ANV.Accounts.User

    timestamps()
  end

  def changeset(
    %__MODULE__{} = credential,
    %{} = attrs
  ) do

    min_length =
      case Map.get(attrs, :password_length) do
        nil -> 7
        length -> length
      end

    fields =
      [
        :password,
        :password_length,
      ]

    credential
    |> cast(attrs, fields)
    |> validate_required(fields)

    |> validate_length(
         :password,
         min: min_length,
         max: 128
       )
    |> put_passwd_hash()
  end

  defp put_passwd_hash(changeset) do

    case changeset do

      %Ecto.Changeset{
        valid?: true,
        changes: %{password: passwd}
      } ->
        put_change(
          changeset,
          :password_hash,
          Argon2.hash_pwd_salt(passwd)
        )

      _ ->
        changeset
    end
  end

  # TODO https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html#Email_Address_Validation (escpecially, normalize email addresses!)
  # (No email yet, but may be added to enable notifications. User input needed at all? It could be pulled from the other DB.)

  # TODO
  # https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html
  # https://pages.nist.gov/800-63-3/sp800-63b.html#sec5
  # + see entire document (on the sidebar there is also 63-A, 63-C, etc.
  # + and especially section 5 Authenticator and Verifier Requirements
  #
  # Some authenticator libraries that need eval:
  # + https://github.com/axelson/password-validator/issues/4
  # + https://github.com/riverrun/not_qwerty123/blob/9778ab77db866778ad7a5874be6f4cf2818a5933/lib/not_qwerty123/password_strength.ex
  # + https://github.com/heresydev/password
  # + https://www.npmjs.com/package/owasp-password-strength-test

  # TODO strengthen password settings in production

  # TODO Add password validation field next to password.

end
