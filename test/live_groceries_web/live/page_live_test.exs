defmodule LiveGroceriesWeb.PageLiveTest do
  use LiveGroceriesWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveGroceries.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  test "disconnected and connected render", %{conn: conn, user: user} do
    {:ok, page_live, disconnected_html} = conn |> log_in_user(user) |> live("/")
    assert disconnected_html =~ "Grocery List</h1>"
    assert render(page_live) =~ "Grocery List</h1>"
  end
end
