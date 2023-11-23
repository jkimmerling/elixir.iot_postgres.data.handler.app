defmodule PostgresPopulater.PortfolioRepo do
  use Ecto.Repo,
    otp_app: :postgres_populater,
    adapter: Ecto.Adapters.Postgres
end
