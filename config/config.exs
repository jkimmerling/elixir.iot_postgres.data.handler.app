import Config

config :postgres_data_handler, PostgresDataHandler.ProjectsRepo,
  database: "projects",
  username: "postgres",
  password: "mysecretpassword",
  hostname: "172.17.0.2"

config :postgres_data_handler, PostgresDataHandler.PortfolioRepo,
  database: "portfolio",
  username: "postgres",
  password: "mysecretpassword",
  hostname: "172.17.0.2"

config :postgres_data_handler,
  ecto_repos: [PostgresDataHandler.PortfolioRepo, PostgresDataHandler.ProjectsRepo]
