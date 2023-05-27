defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Models.Topic
  alias Discuss.Repo

  def index(conn, _params) do
    topics = Repo.all(Topic)

    conn
    |> put_root_layout(html: false)
    |> render(:index, topics: topics)
  end

  def new(conn, _params) do
   changeset = Topic.changeset(%Topic{}, %{})

   conn
   |> put_root_layout(html: false)
   |> render(:new, changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: path(conn, ~p"/"))
      {:error, changeset} ->
        conn
        |> put_root_layout(html: false)
        |> render(:new, changeset: changeset)
    end
  end
end