defmodule TodoWeb.ItemFormComponent do
  use TodoWeb, :live_component
  alias Todo.{Item, Todos}

  def mount(socket) do
    {:ok, assign(socket, %{item_form_modal: false})}
  end

  def handle_event("validate", %{"item" => params}, socket) do
    changeset =
      %Item{}
      |> Item.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"item" => params}, socket) do
    list_id = socket.assigns.list_id
    %{"id" => id} = params
    is_update_call = id != ""

    result =
      if is_update_call,
        do: Todos.update_item(id, params),
        else: Todos.create_item(list_id, params)

    case result do
      {:ok, _} ->
        message =
          if is_update_call, do: "Item Update Successfully", else: "Item Create Successfully"

        send(self(), :after_item_upsert)
        send(self(), {:show_flash, %{message: message, type: :info}})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}

      {:error, %{message: message}} ->
        send(self(), {:show_flash, %{message: message, type: :error}})
        {:noreply, socket}
    end
  end
end
