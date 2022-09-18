defmodule Todo.Todos do
  alias Todo.{Repo, List, Item}
  import Ecto.Query

  @day_in_second -86400
  def get_lists() do
    query = from(l in List, order_by: l.inserted_at)

    Repo.all(query)
    |> Repo.preload([:items])
  end

  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  def create_item(list_id, attrs \\ %{}) do
    with list = %List{} <- get_list(list_id),
         false <- is_list_archived(list) do
      %Item{}
      |> Item.changeset(attrs)
      |> Repo.insert()
    else
      nil ->
        {:error, %{message: "List does not exist"}}

      true ->
        {:error, %{message: "List is archived"}}
    end
  end

  def update_archived_status(id, attrs) do
    with list = %List{} <- get_list(id) do
      list
      |> List.update_archived_changeset(attrs)
      |> Repo.update()
    else
      nil ->
        {:error, %{message: "List does not exist"}}
    end
  end

  def update_list(id, attrs \\ %{}) do
    with list = %List{} <- get_list(id),
         false <- is_list_archived(list) do
      list
      |> List.changeset(attrs)
      |> Repo.update()
    else
      nil ->
        {:error, %{message: "List does not exist"}}

      true ->
        {:error, %{message: "List is archived"}}
    end
  end

  def update_item(id, attrs \\ %{}) do
    with item = %Item{} <- get_item(id),
         false <- is_list_archived(item.list) do
      item
      |> Item.changeset(attrs)
      |> Repo.update()
    else
      nil ->
        {:error, %{message: "Item does not exist"}}

      true ->
        {:error, %{message: "List is archived"}}
    end
  end

  def archived_old_list() do
    datetime_before_24_hour = DateTime.add(DateTime.utc_now(), @day_in_second)

    from(l in Todo.List,
      where: l.archived == false and l.updated_at < ^datetime_before_24_hour
    )
    |> Repo.update_all(set: [archived: true])
  end

  def get_list(id) do
    Repo.get(List, id)
  end

  def get_item(id) do
    Repo.get(Item, id)
    |> Repo.preload(list: from(l in List, select: %{archived: l.archived}))
  end

  defp is_list_archived(list) do
    case list.archived do
      true ->
        true

      _ ->
        false
    end
  end
end
