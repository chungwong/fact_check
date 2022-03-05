defmodule FactCheck.Facts.Stat do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]
  @primary_key false

  @required_fields ~w(ip)a
  @optional_fields ~w()a

  @primary_key false
  schema "stats" do
    field :ip, EctoNetwork.INET

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(fact, attrs) do
    fact
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
