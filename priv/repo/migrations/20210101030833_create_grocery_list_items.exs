defmodule LiveGroceries.Repo.Migrations.CreateGroceryListItems do
  use Ecto.Migration

  def change do
    create table(:grocery_list_items) do
      add :name, :string, null: false
      add :position, :integer, null: false
      add :completed, :boolean, default: false, null: false
      add :owned_by_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:grocery_list_items, [:owned_by_id])
  end
end
