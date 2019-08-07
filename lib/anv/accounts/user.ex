defmodule ANV.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  # https://stackoverflow.com/questions/45856232/code-duplication-in-elixir-and-ecto

  schema "users" do
    field :username,      :string
    field :password,      :string, virtual: true
    field :password_hash, :string

    embeds_one :roles, Roles do
      field :admin, :boolean
      embeds_one :volunteer, Volunteer do
        field :res_dev_id, :string
      end
    end

    timestamps()
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

  # `min_length` for admins will have to be significantly larger
  def registration_changeset(user, attrs, [passwd_min_length: min]) do

    fields = [:username, :password]

    user
    |> cast(attrs, fields)
    |> validate_required(fields)

    |> validate_length(:username, max: 27)
    |> unique_constraint(:username)

    |> validate_length(:password, min: min, max: 128)
    |> put_passwd_hash()

    |> cast_embed(:roles, required: true, with: &roles_changeset/2)
  end

  def roles_changeset(roles, attrs) do

    fields = [:admin]

    roles
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> cast_embed(:volunteer, required: true, with: &volunteer_changeset/2)
  end

  def volunteer_changeset(volunteer, attrs) do

    fields = [:res_dev_id]

    volunteer
    |> cast(attrs, fields)
    |> validate_required(fields)
    # Holding off on `validate_format/4` until making sure
    # what `:res_dev_id`s will look like.
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
