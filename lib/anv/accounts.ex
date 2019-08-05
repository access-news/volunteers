defmodule ANV.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias ANV.Accounts.User
  alias ANV.Repo

  def list_users do
    Repo.all(User)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  # def change_user(%User{} = user) do
  #   User.changeset(user, %{})
  # end

  # def create_user(attrs \\ %{}) do
  #   %User{}
  #   |> User.changeset(attrs)
  #   |> Repo.insert()
  # end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  # TODO Clever and short again, but not explicit. How would this be solved
  #      in Haskell or Purescript? (i.e., using category theory)
  def auth_by_email_and_passwd(email, given_passwd) do
    user = get_user_by(email: email)

    cond do
      # if user exists, and password is correct, return :ok
      user && Argon2.verify_pass(given_passwd, user.password_hash) ->
        {:ok, user}

      # If the user exists, but password didn't match, return :error
      user ->
        {:error, :unauthorized}

      # if there is no existing user with that email, do a bogus calculation
      # to prevent timing attacks
      true ->
        Argon2.no_user_verify()
        {:error, :not_found}
    end
  end
end
