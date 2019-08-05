defmodule ANV.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    # TODO https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html#Email_Address_Validation (escpecially, normalize email addresses!)
  end

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
  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 10, max: 128)
    |> put_passwd_hash()
  end

  defp put_passwd_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: passwd}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(passwd))

      _ ->
        changeset
    end
  end
end
