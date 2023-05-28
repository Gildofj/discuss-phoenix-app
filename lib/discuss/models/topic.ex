defmodule Discuss.Models.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topic" do
    field :title, :string
    belongs_to :user, Discuss.Models.User
    has_many :comment, Discard.Models.Comment

    timestamps()
  end

  @doc false
  def changeset(topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
