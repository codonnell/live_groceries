defmodule LiveGroceriesWeb.PageLiveTest do
  use LiveGroceriesWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveGroceries.AccountsFixtures
  import LiveGroceries.GroceryListFixtures

  setup do
    %{user: user_fixture()}
  end

  test "disconnected and connected render", %{conn: conn, user: user} do
    {:ok, page_live, disconnected_html} = conn |> log_in_user(user) |> live("/")
    assert disconnected_html =~ "Grocery List</h1>"
    assert render(page_live) =~ "Grocery List</h1>"
  end

  test "render item list", %{conn: conn, user: user} do
    item1 = item_fixture(user)
    item2 = item_fixture(user)

    {:ok, _view, html} = conn |> log_in_user(user) |> live("/")
    assert html =~ listing_regex([item1, item2])
  end

  test "render item list with completed item", %{conn: conn, user: user} do
    item1 = item_fixture(user, %{completed: true})
    item2 = item_fixture(user)

    {:ok, _view, html} = conn |> log_in_user(user) |> live("/")
    assert html =~ listing_regex([item2, item1])
  end

  test "create item", %{conn: conn, user: user} do
    {:ok, view, _html} = conn |> log_in_user(user) |> live("/")
    assert render_keyup(view, :create_item, %{"value" => "item1"}) =~ "item1"
  end

  describe "update_item" do
    setup do
      user = user_fixture()
      item = item_fixture(user, %{name: "name", completed: false})
      %{user: user, item: item}
    end

    test "update name", %{conn: conn, user: user, item: item} do
      {:ok, view, _html} = conn |> log_in_user(user) |> live("/")

      assert render_keyup(view, :update_item_name, %{
               "id" => Integer.to_string(item.id),
               "value" => "updated_name"
             }) =~
               "updated_name"
    end

    test "complete item", %{conn: conn, user: user, item: item} do
      {:ok, view, _html} = conn |> log_in_user(user) |> live("/")

      assert render_keyup(view, :toggle_item_completed, %{"id" => Integer.to_string(item.id)}) =~
               "checked"

      assert !(render_keyup(view, :toggle_item_completed, %{"id" => Integer.to_string(item.id)}) =~
                 "checked")
    end
  end

  test "delete item", %{conn: conn, user: user} do
    item = item_fixture(user)

    {:ok, view, html} = conn |> log_in_user(user) |> live("/")

    assert html =~ item.name
    assert !(render_click(view, :delete_item, %{"id" => Integer.to_string(item.id)}) =~ item.name)
  end

  defp listing_regex(items) do
    re_str =
      items
      |> Enum.map(&Regex.escape(&1.name))
      |> Enum.join(".*")

    Regex.compile!(re_str, "s")
  end
end
