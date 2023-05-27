defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Models.Topic
  alias Discuss.Repo

  def index(conn, _params) do
    topics = Repo.all(Topic)

    renderPage conn, :index, topics: topics
  end

  def new(conn, _params) do
   changeset = Topic.changeset(%Topic{}, %{})

   renderPage conn, :new, changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, post} ->
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
      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: path(conn, ~p"/"))
      {:error, changeset} -> renderPage conn, :edit, changeset: changeset, id: id
    end
  end

  def delete(conn, %{"id" => id}) do
    changeset = Repo.get(Topic, id)

    case Repo.delete(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic Removed")
        |> renderPage(:index)
      {:error, changeset} -> renderPage conn, :index, changeset
    end
  end

  defp renderPage(conn, path, args \\ %{}) do
    conn
    |> put_root_layout(html: false)
    |> render(path, args)
  end

end