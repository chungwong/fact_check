defmodule FactCheckWeb.PageController do
  use FactCheckWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
