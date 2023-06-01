defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn

  alias Discuss.Models.User
  alias Discuss.Repo

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        conn
        |> assign(:user_token, Phoenix.Token.sign(conn, "key", user.id))
        |> assign(:user, user)
      true ->
        assign(conn, :user, nil)
    end
  end
end
