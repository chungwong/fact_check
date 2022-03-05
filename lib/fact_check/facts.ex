defmodule FactCheck.Facts do
  @moduledoc """
  Gets random facts from https://uselessfacts.jsph.pl/random.json
  and stores a copy of the facts in database. Queries to the facts are counted
  on each request.
  """

  import Ecto.Query, warn: false
  alias FactCheck.Repo

  alias FactCheck.Facts.{Fact, Stat}

  @endpoint "https://uselessfacts.jsph.pl"

  @one_day 86400

  def get_fact(id), do: Repo.get(Fact, id)

  @spec get_jsph(String.t()) :: {:ok, Fact.t()} | {:error, any}
  defp get_jsph(url) when is_binary(url) do
    HTTPoison.get(url)
    |> case do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        %{
          "id" => id,
          "source" => source,
          "source_url" => source_url,
          "text" => text,
          "language" => lang,
          "permalink" => permalink
        } = Jason.decode!(body)

        if fact = get_fact(id) do
          # arguably `:view_count` should be taken the current request into consideration.
          # For example, if the `view_count` is 11 and for this 12th request. As the response is not
          # finished yet, it is arguably there is still 11 views.
          #
          # In this case, the current `:view_count` is returned and any errors on updating will be silently swallowed
          update_fact(fact, %{view_count: fact.view_count + 1})

          {:ok, fact}
        else
          create_fact(%{
            id: id,
            text: text,
            source: source,
            source_url: source_url,
            lang: lang,
            permalink: permalink,
            view_count: 1
          })
        end

      _ ->
        {:error, "There was an error"}
    end
  end

  @doc """
  Given an id, try to serve that fact
  """
  @spec get_fact_by_id(String.t()) :: {:ok, Fact.t()} | {:error, any}
  def get_fact_by_id(id) when is_binary(id) do
    Path.join([@endpoint, id <> ".json"])
    |> get_jsph()
  end

  def get_fact_by_id(nil), do: {:error, "id is required"}

  @doc """
  Gets a random fact
  """
  @spec get_random_fact() :: {:ok, Fact.t()} | {:error, any}
  def get_random_fact() do
    get_jsph(Path.join(@endpoint, "random.json"))
  end

  def create_fact(attrs \\ %{}) do
    %Fact{}
    |> Fact.changeset(attrs)
    |> Repo.insert()
  end

  def update_fact(%Fact{} = fact, attrs) do
    fact
    |> Fact.changeset(attrs)
    |> Repo.update()
  end

  def change_fact(%Fact{} = fact, attrs \\ %{}) do
    Fact.changeset(fact, attrs)
  end

  def create_stat(%Plug.Conn{} = conn) do
    %Stat{}
    |> Stat.changeset(%{ip: conn.remote_ip})
    |> Repo.insert()

    conn
  end

  @doc """
  Given a time, summarise all requests made since that time.
  """
  @spec get_stats(pos_integer) :: map
  def get_stats(time \\ @one_day) do
    target =
      DateTime.utc_now()
      |> DateTime.add(-time, :second)

    all_reqs =
      from(
        s in Stat,
        select: count("*"),
        where: s.inserted_at >= ^target
      )
      |> Repo.one()

    %{
      reqs: all_reqs
    }
  end
end
