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
    archived_List()

    {:noreply, nil, :hibernate}
  end

  defp archived_List() do
    Todos.archived_old_list()
  end
end
