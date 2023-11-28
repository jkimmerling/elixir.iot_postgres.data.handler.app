defmodule PostgresDataHandler.PortfolioRepo do
  use Ecto.Repo,
    otp_app: :postgres_data_handler,
    adapter: Ecto.Adapters.Postgres

    def init(_type, config) do
      config = Keyword.put(config, :username, System.get_env("PORTFOLIO_DB_USERNAME"))
      config = Keyword.put(config, :password, System.get_env("PORTFOLIO_DB_PASSWORD"))
      config = Keyword.put(config, :hostname, System.get_env("PORTFOLIO_DB_HOSTNAME"))

      {:ok, config}
    end
end
