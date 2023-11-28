import Config

config :postgres_data_handler, PostgresDataHandler.ProjectsRepo,
  database: "projects",
  log: false

config :postgres_data_handler, PostgresDataHandler.PortfolioRepo,
  database: "portfolio",
  log: false

config :postgres_data_handler,
  ecto_repos: [PostgresDataHandler.PortfolioRepo, PostgresDataHandler.ProjectsRepo]
