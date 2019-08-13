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

  # TODO 2019-08-13_1446 How to break out early?
  # def delete_user(id) do
  #   id
  #   |> get_user()
  #   |> Repo.delete()
  # end

  def delete_user!(id) do
    id
    |> get_user!()
    |> Repo.delete!()
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def get_roles(user) do
    Enum.map(user.roles, &Map.get(&1, :role))
  end

  def is_admin?(user) do
    "admin" in ANV.Accounts.get_roles(user)
  end

  # Needed to render forms (until moving to a frontend framework?)
  # no args are really needed, because called with empty User struct and empty map
  def change_registration(user \\ %User{}, params)
  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  # TODO
  # Clever and short again,  but not explicit. How would
  # this  be solved  in  Haskell  or Purescript?  (i.e.,
  # using category theory)
  def auth_by_username_and_passwd(username, given_passwd) do

    user = get_user_by(username: username)

    cond do
      # if  user  exists, and  password is  correct,
      # return :ok
      user && Argon2.verify_pass(given_passwd, user.password_hash) ->
        {:ok, user}

      # If  the  user  exists,  but password  didn't
      # match, return :error
      user ->
        {:error, :unauthorized}

      # if  there  is  no existing  user  with  that
      # username, do a bogus calculation to  prevent
      # timing attacks
      true ->
        Argon2.no_user_verify()
        {:error, :not_found}
    end
  end
end
