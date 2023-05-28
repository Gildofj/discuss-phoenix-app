defmodule DiscussWeb.Plug.RequireAuth do

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You most be logged in")
      |> redirect(to: path(conn, ~p"/"))
      |> halt()
    end
  end
end