defmodule LiveGroceriesWeb.PageLive do
  use LiveGroceriesWeb, :live_view

  alias LiveGroceries.Accounts
  alias LiveGroceries.GroceryList

  alias Phoenix.PubSub

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    PubSub.subscribe(LiveGroceries.PubSub, pubsub_topic(user))
    {:ok, assign(socket, current_user: user, items: GroceryList.list_user_items(user))}
  end

  @impl true
  def handle_event("create_item", params, socket) do
    user = socket.assigns.current_user
    items = socket.assigns.items

    next_position =
      Enum.max_by(items, & &1.position, &>=/2, fn -> %{position: 0} end).position + 1

    {:ok, _} =
      GroceryList.create_item(user, %{
        name: params["value"],
        position: next_position,
        completed: false
      })

    {:noreply, refresh_items(socket)}
  end

  @impl true
  def handle_event("delete_item", %{"id" => id_str}, socket) do
    {id, _} = Integer.parse(id_str)
    user = socket.assigns.current_user
    item = GroceryList.get_user_item!(user, id)
    GroceryList.delete_item(item)
    {:noreply, refresh_items(socket)}
  end

  @impl true
  def handle_event("toggle_item_completed", %{"id" => id_str}, socket) do
    update_item(socket.assigns.current_user, id_str, fn %{completed: completed} ->
      %{completed: !completed}
    end)

    {:noreply, refresh_items(socket)}
  end

  @impl true
  def handle_event("update_item_name", %{"id" => id_str, "value" => value}, socket) do
    update_item(socket.assigns.current_user, id_str, fn _ -> %{name: value} end)
    {:noreply, refresh_items(socket)}
  end

  defp update_item(user, id_str, attrs_fn) do
    {id, _} = Integer.parse(id_str)
    item = GroceryList.get_user_item!(user, id)
    attrs = attrs_fn.(item)
    GroceryList.update_item(item, attrs)
  end

  defp refresh_items(socket) do
    user = socket.assigns.current_user
    items = GroceryList.list_user_items(user)

    PubSub.broadcast_from(
      LiveGroceries.PubSub,
      self(),
      pubsub_topic(user),
      {:refresh_items, items}
    )

    assign(socket, items: items)
  end

  @impl true
  def handle_info({:refresh_items, items}, socket) do
    {:noreply, assign(socket, items: items)}
  end

  defp pubsub_topic(user), do: "grocery_list:#{user.id}"
end
