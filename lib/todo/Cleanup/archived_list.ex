defmodule Todo.ArchivedList do
  use GenServer
  alias Todo.{Todos}

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_cast(:start_archiving, _) do
    {updation_count, _} = archived_List()

    if updation_count >= 1 do
      Phoenix.PubSub.broadcast(Todo.PubSub, "archived_cleanup", {:fetch_todo_list})
    end

    {:noreply, nil, :hibernate}
  end

  defp archived_List() do
    Todos.archived_old_list()
  end
end
