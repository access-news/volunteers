defmodule ANVWeb.VolunteerController do
  use ANVWeb, :controller

  def new(conn, TODO_extract_resdevid) do
    changeset = Accounts.volunteer_registration_changeset()
    render(
      conn,
      "new.html",
      res_dev_id: res_dev_id,
      changeset:  changeset
    )
  end

  def create(conn, %{ "volunteer" => volunteer_params }) do
    case Accounts.register_volunteer(volunteer_params) do
      {:ok, volunteer} ->
        conn
        |> ANVWeb.Auth.login(volunteer)
        |> put_flash(:info, "#{volunteer.username} added!")
        # |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
