defmodule LiveGroceries.GroceryListTest do
  use LiveGroceries.DataCase, async: true

  import LiveGroceries.AccountsFixtures

  alias LiveGroceries.GroceryList

  describe "items" do
    alias LiveGroceries.Accounts
    alias LiveGroceries.GroceryList.Item

    @valid_attrs %{completed: false, name: "some name", position: 1}
    @update_attrs %{
      completed: true,
      name: "some updated name",
      position: 2
    }
    @invalid_attrs %{completed: false, name: nil, position: nil}

    def item_fixture(%Accounts.User{} = user, attrs \\ %{}) do
      attrs = Enum.into(attrs, @valid_attrs)
      {:ok, item} = GroceryList.create_item(user, attrs)
      item
    end

    test "list_items/0 returns all items" do
      user = user_fixture()
      %Item{id: id1} = item_fixture(user)
      assert [%Item{id: ^id1}] = GroceryList.list_user_items(user)
      %Item{id: id2} = item_fixture(user)

      assert [%Item{id: ^id1}, %Item{id: ^id2}] = GroceryList.list_user_items(user)
    end

    test "list_items/0 returns items ordered by position" do
      user = user_fixture()
      %Item{id: id1} = item_fixture(user, %{position: 2})
      %Item{id: id2} = item_fixture(user, %{position: 1})

      assert [%Item{id: ^id2}, %Item{id: ^id1}] = GroceryList.list_user_items(user)
    end

    test "get_user_item!/1 returns the item with given id" do
      user = user_fixture()
      %Item{id: id} = item_fixture(user)

      assert %Item{id: ^id} = GroceryList.get_user_item!(user, id)
    end

    test "create_item/1 with valid data creates a item" do
      user = user_fixture()

      assert {:ok, %Item{} = item} = GroceryList.create_item(user, @valid_attrs)

      assert item.completed == @valid_attrs.completed
      assert item.name == @valid_attrs.name
      assert item.position == @valid_attrs.position
    end

    test "create_item/1 with invalid data returns error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} = GroceryList.create_item(user, @invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      user = user_fixture()
      item = item_fixture(user)

      assert {:ok, %Item{} = item} = GroceryList.update_item(item, @update_attrs)

      assert item.completed == @update_attrs.completed
      assert item.name == @update_attrs.name
      assert item.position == @update_attrs.position
    end

    test "update_item/2 with invalid data returns error changeset" do
      user = user_fixture()
      item = item_fixture(user)
      %Item{id: id} = item

      assert {:error, %Ecto.Changeset{}} = GroceryList.update_item(item, @invalid_attrs)

      after_item = GroceryList.get_user_item!(user, id)
      assert after_item.completed == @valid_attrs.completed
      assert after_item.name == @valid_attrs.name
      assert after_item.position == @valid_attrs.position
    end

    test "delete_item/1 deletes the item" do
      user = user_fixture()
      item = item_fixture(user)
      assert {:ok, %Item{}} = GroceryList.delete_item(item)

      assert_raise Ecto.NoResultsError, fn ->
        GroceryList.get_user_item!(user, item.id)
      end
    end

    test "change_item/1 returns a item changeset" do
      user = user_fixture()
      item = item_fixture(user)
      assert %Ecto.Changeset{} = GroceryList.change_item(item)
    end
  end
end
