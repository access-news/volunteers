defmodule ANVWeb.SignupController do
  use ANVWeb, :controller

  # TODO 2019-08-13_1501 implement signup link

  def new(conn, _TODO_extract_resdevid) do
    # changeset = Accounts.volunteer_registration_changeset()
    # render(
    #   conn,
    #   "new.html",
    #   res_dev_id: res_dev_id,
    #   changeset:  changeset
    # )
  end

  def create(conn, %{ "volunteer" => volunteer_params }) do
    # case Accounts.register_volunteer(volunteer_params) do
    #   {:ok, volunteer} ->
    #     conn
    #     |> ANVWeb.Auth.login(volunteer)
    #     |> put_flash(:info, "#{volunteer.username} added!")
    #     # |> redirect(to: Routes.user_path(conn, :index))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end
end
