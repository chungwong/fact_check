defmodule FactCheckWeb.FactController do
  use FactCheckWeb, :controller

  alias FactCheck.Facts

  require Logger

  def get_fact(conn, params) do
    Map.get(params, "id")
    |> Facts.get_fact_by_id()
    |> case do
      {:ok, fact} ->
        json(conn, fact)

      {:error, msg} when is_binary(msg) ->
        Logger.error("get fact error: #{msg}")

        conn
        |> put_status(500)
        |> json(%{error: msg})

      e ->
        Logger.error("Unknown get fact error: #{inspect(e)}")

        conn
        |> put_status(500)
        |> json(%{error: "Unknown Error"})
    end
  end

  def get_random(conn, _) do
    Facts.get_random_fact()
    |> case do
      {:ok, fact} ->
        json(conn, fact)

      {:error, msg} when is_binary(msg) ->
        Logger.error("get random fact error: #{msg}")

        conn
        |> put_status(500)
        |> json(%{error: msg})

      e ->
        Logger.error("Unknown get random fact error: #{inspect(e)}")

        conn
        |> put_status(500)
        |> json(%{error: "Unknown Error"})
    end
    |> Facts.create_stat()
  end

  def stat(conn, _params) do
    # TODO let users specify the timeframe in `params` and pass it to `get_stats/1`

    json(conn, Facts.get_stats())
  end
end
