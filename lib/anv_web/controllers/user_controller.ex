defmodule ANVWeb.UserController do
  use ANVWeb, :controller

  alias ANV.Accounts

  # --- PLUGGED ----------------------------------------

  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  # ----------------------------------------------------

  # registration
  def new(conn, _params) do
    changeset = Accounts.change_registration(%Accounts.User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  # post registration form
  def create(conn, %{"user" => user_params}) do
    # case Accounts.create_user(user_params) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> ANVWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} added!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
