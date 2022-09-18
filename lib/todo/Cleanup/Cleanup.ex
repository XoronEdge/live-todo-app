defmodule Todo.Cleanup do
  use GenServer
  alias Todo.{ArchivedList}

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    Process.send_after(self(), :archived_lists, :timer.minutes(5))
    ArchivedList.start_link()
    {:ok, nil}
  end

  def handle_info(:archived_lists, _) do
    archived_old_updated_List()
    Process.send_after(self(), :archived_lists, :timer.minutes(5))
    {:noreply, nil}
  end

  defp archived_old_updated_List() do
    GenServer.cast(ArchivedList, :start_archiving)
  end
end
