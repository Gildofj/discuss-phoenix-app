defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Models.Topic
  alias Discuss.Repo

  @impl true
  def join("comments:" <> topic_id, _payload, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Repo.get(Topic, topic_id)

    {:ok, %{}, socket}
  end

  @impl true
  def handle_in(name, message, socket) do
    {:reply, :ok, socket}
  end
end
