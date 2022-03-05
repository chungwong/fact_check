defmodule FactCheck.Facts.Fact do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]
  @primary_key false

  @required_fields ~w(id text source source_url lang permalink)a
  @optional_fields ~w(view_count)a

  @derive {Jason.Encoder, only: @required_fields}
  schema "facts" do
    field :id, :string, primary_key: true
    field :text, :string
    field :lang, :string
    field :permalink, :string
    field :source, :string
    field :source_url, :string
    field :view_count, :integer

    timestamps()
  end

  @doc false
  def changeset(fact, attrs) do
    fact
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
