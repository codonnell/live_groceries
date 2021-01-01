defmodule LiveGroceries.GroceryList.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "grocery_list_items" do
    field :completed, :boolean, default: false
    field :name, :string
    field :position, :integer

    belongs_to :owned_by, LiveGroceries.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :position, :completed])
    |> validate_required([:name, :position, :completed])
  end
end
