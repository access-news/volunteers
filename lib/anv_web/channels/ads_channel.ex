defmodule ANVWeb.ArticlesChannel do
  use Phoenix.Channel

  def join("ads:changed", payload, socket) do
    # require IEx; IEx.pry
    {:ok, %{body: "balabab"}, socket}
  end

  def handle_in(
    "reserve_clicked",
    %{ "page_id" => page_id } = page_id_map,
    socket
  ) do

    [store_id, page_number] = String.split(page_id, "-")

    case ANV.Articles.reserve(store_id, page_number) do

      :ok ->
        broadcast(socket, "reserve_page", page_id_map)

      # error defined in ANV.Articles.Reserve.reserve/1
      {:error, event} -> 
        push(socket, event, %{ body: "Already reserved", })
    end

    {:noreply, socket}
  end
end
