defmodule TodoWeb.TodoComponent do
  use Phoenix.Component
  use Phoenix.HTML

  def list_item(assigns) do
    ~H"""
    <li class="flex flex-row" id={"item#{@item.id}"}>
          <div
            class="select-none hover:bg-gray-50 flex flex-1 items-center p-4"
          >
            <div class="flex-1 pl-1">
              <h2 class="font-light cursor-pointer dark:text-white" phx-click="update_item" phx-value-item_id={@item.id}>
               <%= @item.content %>
              </h2>
            </div>
            <div class="flex flex-row justify-center">
                <div class="form-check" id={"item-form#{@item.id}"}>
                <label class="form-check-label inline-block text-gray-800" for="flexCheckChecked">
                    Completed
                 </label>
                 <%= checkbox :item, :completed, checked: @item.completed, id: "item-checkbox#{@item.id}",value: @item.completed, phx_click: "toggle_item_completed", phx_value_itemid: @item.id, phx_value_completed: if @item.completed, do: 1, else: 0 %>
              </div>
            </div>
          </div>
        </li>
    """
  end

  def list(assigns) do
    ~H"""
    <div
    id={"list#{@list.id}"}
    class="flex flex-col p-2 container max-w-md mt-10 mx-auto w-full bg-white dark:bg-gray-800 rounded-lg shadow"
    >
    <div class="flex flex-row justify-between">
      <h1 class="text-xl font-medium cursor-pointer" phx-click="update_list" phx-value-list_id={@list.id}><%= @list.title %></h1>
      <div class="flex flex-row justify-center items-center">
        <div class="form-check" id={"list-form#{@list.id}"}>
          <label class="form-check-label inline-block text-gray-800" for="flexCheckChecked">
              Archived
          </label>
          <%= checkbox :list, :archived, checked: @list.archived, id: "list-checkbox#{@list.id}", value: @list.archived, phx_click: "toggle_list_archived", phx_value_listid: @list.id, phx_value_archived: if @list.archived, do: 1, else: 0 %>
           <%# <input phx-click="toggle_list_archived" phx-value-list_id={list.id} phx-value-archived={list.archived} class="form-check-input appearance-none h-4 w-4 border border-gray-300 rounded-sm bg-white checked:bg-blue-600 checked:border-blue-600 my-1 align-top bg-no-repeat bg-center bg-contain cursor-pointer" type="checkbox" value={list.archived} id="flexCheckChecked3" checked={list.archived}>                %>
        </div>
        <button phx-click="add_item" phx-value-list_id={@list.id} type="button" class="ml-2 inline-block px-2 py-1.5 bg-gray-500 text-white font-medium text-xs leading-tight uppercase rounded shadow-md">
          Add Item
        </button>
      </div>
    </div>
    <%= if Enum.empty?(@list.items) do %>
    <h1 class="font-medium cursor-pointer dark:text-white">List contain no item</h1>
    <% end %>
    <ul class="flex flex-col divide-y w-full">
      <%= for item <- @list.items do %>
      <.list_item  item={item}/>
      <% end %>
    </ul>
     </div>
    """
  end
end
