import Config

config :postgres_populater, PostgresPopulater.ProjectsRepo,
  database: "projects",
  username: "postgres",
  password: "mysecretpassword",
  hostname: "172.17.0.2"

config :postgres_populater, PostgresPopulater.PortfolioRepo,
  database: "portfolio",
  username: "postgres",
  password: "mysecretpassword",
  hostname: "172.17.0.2"

config :postgres_populater,
  ecto_repos: [PostgresPopulater.PortfolioRepo, PostgresPopulater.ProjectsRepo]
