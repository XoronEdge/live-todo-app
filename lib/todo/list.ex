defmodule Todo.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :archived, :boolean, default: false
    field :title, :string
    has_many(:items, Todo.Item)
    timestamps()
  end

  @required ~w(title)a
  @optional ~w(archived)a
  @allowed @required ++ @optional
  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, @allowed)
    |> validate_required(@required)
  end

  def update_archived_changeset(list, attrs) do
    list
    |> cast(attrs, @allowed)
    |> validate_required(@optional)
  end
end
