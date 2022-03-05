defmodule FactCheck.Repo.Migrations.CreateFacts do
  use Ecto.Migration

  def change do
    create table(:facts, primary_key: false) do
      add :id, :text, primary_key: true
      add :text, :text
      add :source, :text
      add :source_url, :text
      add :lang, :string
      add :permalink, :text
      add :view_count, :integer, default: 0

      timestamps(type: :timestamptz)
    end

    unique_index(:facts, [:permalink])

    create table(:stats, primary_key: false) do
      add :ip, :inet
      timestamps(type: :timestamptz, updated_at: false)
    end

    unique_index(:stats, [:inserted_at])
  end
end
