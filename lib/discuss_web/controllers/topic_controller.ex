defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Models.Topic
  alias Discuss.Repo

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics = Repo.all(Topic)

    renderPage conn, :index, topics: topics
  end

  def show(conn, %{"id" => id}) do
    topic = Repo.get!(Topic, id)

    renderPage conn, :show, topic: topic
  end

  def new(conn, _params) do
   changeset = Topic.changeset(%Topic{}, %{})

   renderPage conn, :new, changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns.user
      |> Ecto.build_assoc(:topic)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: path(conn, ~p"/"))
      {:error, changeset} -> renderPage conn, :new, changeset: changeset
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Repo.get(Topic, id)
    changeset = Topic.changeset(topic)

    renderPage conn, :edit, changeset: changeset, id: id
  end

  def update(conn, %{"id" => id, "topic" => topic}) do
    changeset = Repo.get(Topic, id) |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: path(conn, ~p"/"))
      {:error, changeset} -> renderPage conn, :edit, changeset: changeset, id: id
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Topic, id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: path(conn, ~p"/"))
  end

  defp renderPage(conn, path, args \\ %{}) do
    conn
    |> put_root_layout(html: false)
    |> render(path, args)
  end

  def check_topic_owner(%{params: %{"id" => id}} = conn, _params) do
    if conn.assigns.user && Repo.get(Topic, id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot access that")
      |> redirect(to: path(conn, ~p"/"))
      |> halt()
    end
  end
end