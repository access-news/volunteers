defmodule ANV.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias ANV.Repo
  alias ANV.Accounts.{
    Volunteer,
    Admin
  }

  def list_volunteers do
    Repo.all(Volunteer)
  end

  def list_admins do
    Repo.all(Admin)
  end

  def get_user(id) do
    Enum.filter(
      [&get_volunteer/1, &get_admin/1],
      nil,
      fn get_fun ->
        get_fun.(id) != nil
      end
    )
  end

  def get_volunteer!(id) do
    Repo.get!(Volunteer, id)
  end

  def get_volunteer(id) do
    Repo.get(Volunteer, id)
  end

  def get_admin!(id) do
    Repo.get!(Admin, id)
  end

  def get_admin(id) do
    Repo.get(Admin, id)
  end

  def get_volunteer_by(params) do
    Repo.get_by(Volunteer, params)
  end

  def get_admin_by(params) do
    Repo.get_by(Admin, params)
  end

  # Needed to render forms (until moving to a frontend framework?)
  # no args are really needed, because called with empty User struct and empty map
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
  def auth_by_email_and_passwd(email, given_passwd) do
    user = get_user_by(email: email)

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
      # email,  do a  bogus  calculation to  prevent
      # timing attacks
      true ->
        Argon2.no_user_verify()
        {:error, :not_found}
    end
  end
end
