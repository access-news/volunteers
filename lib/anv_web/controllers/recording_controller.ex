defmodule ANVWeb.RecordingController do
  use ANVWeb, :controller

  alias ANV.Media
  alias ANV.Media.Recording

  def index(conn, _params) do
    recordings = Media.list_recordings()
    render(conn, "index.html", recordings: recordings)
  end

  def new(conn, _params) do
    changeset = Media.change_recording(%Recording{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"recording" => recording_params}) do

    require IEx; IEx.pry
    # case Media.create_recording(recording_params) do
    #   {:ok, recording} ->
    #     conn
    #     |> put_flash(:info, "Recording created successfully.")
    #     |> redirect(to: Routes.recording_path(conn, :show, recording))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end

  def show(conn, %{"id" => id}) do
    recording = Media.get_recording!(id)
    render(conn, "show.html", recording: recording)
  end

  def edit(conn, %{"id" => id}) do
    recording = Media.get_recording!(id)
    changeset = Media.change_recording(recording)
    render(conn, "edit.html", recording: recording, changeset: changeset)
  end

  def update(conn, %{"id" => id, "recording" => recording_params}) do
    recording = Media.get_recording!(id)

    case Media.update_recording(recording, recording_params) do
      {:ok, recording} ->
        conn
        |> put_flash(:info, "Recording updated successfully.")
        |> redirect(to: Routes.recording_path(conn, :show, recording))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recording: recording, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    recording = Media.get_recording!(id)
    {:ok, _recording} = Media.delete_recording(recording)

    conn
    |> put_flash(:info, "Recording deleted successfully.")
    |> redirect(to: Routes.recording_path(conn, :index))
  end
end
