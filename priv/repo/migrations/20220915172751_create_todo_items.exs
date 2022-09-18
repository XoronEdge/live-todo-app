defmodule Todo.Repo.Migrations.CreateTodoItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :content, :string
      add :completed, :boolean, default: false, null: false
      add :list_id, references(:lists, on_delete: :delete_all)

      timestamps()
    end

    create index(:items, [:list_id])
  end
end
