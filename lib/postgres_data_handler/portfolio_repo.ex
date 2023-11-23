defmodule PostgresDataHandler.PortfolioRepo do
  use Ecto.Repo,
    otp_app: :postgres_data_handler,
    adapter: Ecto.Adapters.Postgres
end
