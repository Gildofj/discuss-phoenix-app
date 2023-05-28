defmodule Discuss.Models.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comment" do
    field :content, :string
    field :user_id, :id
    field :topic_id, :id
    belongs_to :user, Discuss.Models.User
    belongs_to :topic, Discuss.Models.Topic

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
