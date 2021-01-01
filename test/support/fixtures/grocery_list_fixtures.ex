defmodule LiveGroceries.GroceryListFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveGroceries.GroceryList` context.
  """

  def unique_name, do: "item#{System.unique_integer()}"
  def unique_position, do: System.unique_integer()

  def item_fixture(user, attrs \\ %{}) do
    attrs =
      Enum.into(
        %{
          name: unique_name(),
          position: unique_position(),
          completed: false
        },
        attrs
      )

    {:ok, grocery_list_item} = LiveGroceries.GroceryList.create_item(user, attrs)

    grocery_list_item
  end
end
