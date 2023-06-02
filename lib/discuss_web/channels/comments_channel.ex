defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Models.Topic
  alias Discuss.Models.Comment
  alias Discuss.Repo

  @impl true
  def join("comments:" <> topic_id, _payload, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get(topic_id)
      |> Repo.preload(comment: [:user])

    {:ok, %{comments: topic.comment}, assign(socket, :topic, topic)}
  end

  @impl true
  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    changeset = topic
      |> Ecto.build_assoc(:comment, user_id: user_id)
      |> Comment.changeset(%{content: content})

      case Repo.insert(changeset) do
        {:ok, comment} ->
          broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
          {:reply, :ok, socket}
        {:error, changeset} ->
          {:reply, {:error, %{errors: changeset}}, socket}
      end
  end
end
