defmodule PostgresDataHandler.PortfolioRepo.Migrations.AddProjectListTable do
  use Ecto.Migration

  def up do
    create table(:project_list, prefix: "portfolio_stats") do
      add :project_name, :string
      add :integration_type, :string
      add :source, :string
    end
  end

  def down do
    execute("DROP TABLE portfolio_stats.project_list")
  end
end
