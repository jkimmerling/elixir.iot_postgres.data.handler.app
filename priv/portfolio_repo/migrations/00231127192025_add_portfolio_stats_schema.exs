defmodule PostgresDataHandler.PortfolioRepo.Migrations.AddPortfolioStatsSchema do
  use Ecto.Migration

  def up do
    execute("CREATE SCHEMA portfolio_stats")
  end

  def down do
    execute("DROP SCHEMA portfolio_stats")
  end
end
