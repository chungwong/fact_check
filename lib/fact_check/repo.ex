defmodule FactCheck.Repo do
  use Ecto.Repo,
    otp_app: :fact_check,
    adapter: Ecto.Adapters.Postgres
end
