defmodule Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :completed, :boolean, default: false
    field :content, :string
    belongs_to :list, Todo.List

    timestamps()
  end

  @required ~w(content list_id)a
  @optional ~w(completed)a
  @allowed @required ++ @optional

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, @allowed)
    |> validate_required(@required)
    |> foreign_key_constraint(:list_id)
  end
end
