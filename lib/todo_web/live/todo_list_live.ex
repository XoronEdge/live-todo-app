defmodule TodoWeb.TodoListLive do
  use TodoWeb, :live_view
  alias Todo.{Todos, Item, List}
  alias TodoWeb.Presence
  alias TodoWeb.TodoComponent

  def mount(_params, _, socket) do
    socket =
      socket
      |> fetch_todo_list
      |> init_presence

    {:ok, assign(socket, %{item_form_modal: false, list_form_modal: false})}
  end

  def handle_event("add_item", %{"list_id" => list_id}, socket) do
    item_changeset = Item.changeset(%Item{}, %{list_id: list_id})

    {:noreply,
     assign(socket, %{item_form_modal: true, changeset: item_changeset, list_id: list_id})}
  end

  def handle_event("add_list", _params, socket) do
    list_changeset = List.changeset(%List{}, %{})
    {:noreply, assign(socket, %{list_form_modal: true, changeset: list_changeset})}
  end

  def handle_event("toggle_list_archived", %{"listid" => list_id, "archived" => archived}, socket) do
    archived = if archived == "1", do: true, else: false

    case Todos.update_archived_status(list_id, %{archived: !archived}) do
      {:ok, list = %List{}} ->
        socket = update_todo_list(list, socket)
        {:noreply, socket |> put_flash(:info, "List archived status Updated")}

      {:error, %{message: message}} ->
        {:noreply, socket |> put_flash(:error, message)}
    end
  end

  def handle_event(
        "toggle_item_completed",
        %{"itemid" => item_id, "completed" => completed},
        socket
      ) do
    completed = if completed == "1", do: true, else: false

    case Todos.update_item(item_id, %{completed: !completed}) do
      {:ok, _ = %Item{}} ->
        socket = fetch_todo_list(socket)
        {:noreply, socket |> put_flash(:info, "Item status complete Updated")}

      {:error, %{message: message}} ->
        {:noreply, socket |> put_flash(:error, message)}
    end
  end

  def handle_event("close_modal", _value, socket) do
    {:noreply, assign(socket, %{item_form_modal: false, list_form_modal: false})}
  end

  def handle_event("update_item", %{"item_id" => item_id}, socket) do
    item = Todos.get_item(item_id)
    item_changeset = Item.changeset(item, %{})

    {:noreply,
     assign(socket, %{item_form_modal: true, changeset: item_changeset, list_id: item.list_id})}
  end

  def handle_event("update_list", %{"list_id" => list_id}, socket) do
    list = Todos.get_list(list_id)
    list_changeset = List.changeset(list, %{})

    {:noreply, assign(socket, %{list_form_modal: true, changeset: list_changeset})}
  end

  def handle_info(:after_item_upsert, socket) do
    socket =
      socket
      |> fetch_todo_list()
      |> assign(%{
        list_id: nil,
        changeset: nil,
        item_form_modal: false
      })

    {:noreply, socket}
  end

  def handle_info(:after_list_upsert, socket) do
    socket =
      socket
      |> fetch_todo_list()
      |> assign(%{
        list_id: nil,
        changeset: nil,
        list_form_modal: false
      })

    {:noreply, socket}
  end

  def handle_info({:show_flash, %{message: message, type: type}}, socket) do
    {:noreply, socket |> put_flash(type, message)}
  end

  def handle_info(:fetch_list, socket) do
    socket = fetch_todo_list(socket)
    {:noreply, socket}
  end

  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{visitor_count: count}} = socket
      ) do
    visitor_count = count + map_size(joins) - map_size(leaves)

    {:noreply, assign(socket, :visitor_count, visitor_count)}
  end

  def modal_toggle_class(item_form_modal) do
    if item_form_modal, do: "", else: "hidden"
  end

  defp fetch_todo_list(socket) do
    socket |> assign(:todo_list, Todos.get_lists())
  end

  defp update_todo_list(updated_list, socket) do
    %{todo_list: todo_list} = socket.assigns

    socket
    |> assign(
      :todo_list,
      Enum.map(todo_list, fn list ->
        if list.id == updated_list.id,
          do: Map.put(list, :archived, updated_list.archived),
          else: list
      end)
    )
  end

  defp init_presence(socket) do
    topic = "todo_list"
    initial_count = Presence.list(topic) |> map_size
    TodoWeb.Endpoint.subscribe(topic)

    Presence.track(
      self(),
      topic,
      socket.id,
      %{}
    )

    assign(socket, visitor_count: initial_count)
  end
end
