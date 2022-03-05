defmodule FactCheck.FactsTest do
  use FactCheck.DataCase

  alias FactCheck.Facts

  describe "facts" do
    alias FactCheck.Facts.Fact

    import FactCheck.FactsFixtures

    @invalid_attrs %{fact: nil, id: nil, lang: nil, permalink: nil, source: nil, source_url: nil}

    test "list_facts/0 returns all facts" do
      fact = fact_fixture()
      assert Facts.list_facts() == [fact]
    end

    test "get_fact!/1 returns the fact with given id" do
      fact = fact_fixture()
      assert Facts.get_fact!(fact.id) == fact
    end

    test "create_fact/1 with valid data creates a fact" do
      valid_attrs = %{
        fact: "some fact",
        id: "some id",
        lang: "some lang",
        permalink: "some permalink",
        source: "some source",
        source_url: "some source_url"
      }

      assert {:ok, %Fact{} = fact} = Facts.create_fact(valid_attrs)
      assert fact.fact == "some fact"
      assert fact.id == "some id"
      assert fact.lang == "some lang"
      assert fact.permalink == "some permalink"
      assert fact.source == "some source"
      assert fact.source_url == "some source_url"
    end

    test "create_fact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Facts.create_fact(@invalid_attrs)
    end

    test "update_fact/2 with valid data updates the fact" do
      fact = fact_fixture()

      update_attrs = %{
        fact: "some updated fact",
        id: "some updated id",
        lang: "some updated lang",
        permalink: "some updated permalink",
        source: "some updated source",
        source_url: "some updated source_url"
      }

      assert {:ok, %Fact{} = fact} = Facts.update_fact(fact, update_attrs)
      assert fact.fact == "some updated fact"
      assert fact.id == "some updated id"
      assert fact.lang == "some updated lang"
      assert fact.permalink == "some updated permalink"
      assert fact.source == "some updated source"
      assert fact.source_url == "some updated source_url"
    end

    test "update_fact/2 with invalid data returns error changeset" do
      fact = fact_fixture()
      assert {:error, %Ecto.Changeset{}} = Facts.update_fact(fact, @invalid_attrs)
      assert fact == Facts.get_fact!(fact.id)
    end

    test "delete_fact/1 deletes the fact" do
      fact = fact_fixture()
      assert {:ok, %Fact{}} = Facts.delete_fact(fact)
      assert_raise Ecto.NoResultsError, fn -> Facts.get_fact!(fact.id) end
    end

    test "change_fact/1 returns a fact changeset" do
      fact = fact_fixture()
      assert %Ecto.Changeset{} = Facts.change_fact(fact)
    end
  end
end
