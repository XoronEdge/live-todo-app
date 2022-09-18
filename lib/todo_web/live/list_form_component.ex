defmodule TodoWeb.ListFormComponent do
  use TodoWeb, :live_component
  alias Todo.{List, Todos}

  def mount(socket) do
    {:ok, assign(socket, %{list_form_modal: false})}
  end

  def handle_event("add_list", _params, socket) do
    list_changeset = List.changeset(%List{}, %{})

    {:noreply, assign(socket, %{list_form_modal: true, changeset: list_changeset})}
  end

  def handle_event("validate", %{"list" => params}, socket) do
    changeset =
      %List{}
      |> List.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"list" => params}, socket) do
    %{"id" => id} = params
    is_update_call = id != ""

    result =
      if is_update_call,
        do: Todos.update_list(id, params),
        else: Todos.create_list(params)

    message = if is_update_call, do: "List Update Successfully", else: "List Create Successfully"

    case result do
      {:ok, _} ->
        send(self(), :after_list_upsert)
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
