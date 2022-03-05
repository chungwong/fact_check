defmodule FactCheck.FactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FactCheck.Facts` context.
  """

  @doc """
  Generate a fact.
  """
  def fact_fixture(attrs \\ %{}) do
    {:ok, fact} =
      attrs
      |> Enum.into(%{
        fact: "some fact",
        id: "some id",
        lang: "some lang",
        permalink: "some permalink",
        source: "some source",
        source_url: "some source_url"
      })
      |> FactCheck.Facts.create_fact()

    fact
  end
end
