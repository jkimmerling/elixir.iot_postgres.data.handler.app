defmodule PostgresPopulater do

  def insert_portfolio_row(integration, project_number) do
    Ecto.Adapters.SQL.query!(
      PostgresPopulater.PortfolioRepo,
      "INSERT INTO portfolio_stats.project_list(project_name, integration_type)
      VALUES ('#{integration}_project_#{project_number}', '#{integration}')"
    )
  end

  def populate_portfolio(number_of_projects) do
    Enum.each(["redis", "api"], fn integration ->
      Enum.each(1..number_of_projects, fn project_number -> insert_portfolio_row(integration, project_number) end)
    end)
  end

  def create_portfolio_schemas() do
    Ecto.Adapters.SQL.query!(
      PostgresPopulater.PortfolioRepo,
      "CREATE SCHEMA IF NOT EXISTS portfolio_stats
      AUTHORIZATION postgres"
    )

    Ecto.Adapters.SQL.query!(
      PostgresPopulater.PortfolioRepo,
      "CREATE TABLE IF NOT EXISTS portfolio_stats.project_list (
        id SERIAL PRIMARY KEY,
        project_name text NOT NULL,
        integration_type text NOT NULL
      )"
    )
  end

  def create_project_schema_and_table(integration, project_number) do
    Ecto.Adapters.SQL.query!(
      PostgresPopulater.ProjectsRepo,
      "CREATE SCHEMA IF NOT EXISTS #{integration}_project_#{project_number}
      AUTHORIZATION postgres"
    )
    Ecto.Adapters.SQL.query!(
      PostgresPopulater.ProjectsRepo,
      "CREATE TABLE IF NOT EXISTS  #{integration}_project_#{project_number}.points (
        id SERIAL PRIMARY KEY,
        point_name text NOT NULL,
        point_path text NOT NULL,
        point_type text NOT NULL
      )"
    )
    Ecto.Adapters.SQL.query!(
      PostgresPopulater.ProjectsRepo,
      "CREATE TABLE IF NOT EXISTS  #{integration}_project_#{project_number}.readings (
        id SERIAL PRIMARY KEY,
        point_id INT NOT NULL,
        point_name text NOT NULL,
        point_path text NOT NULL,
        point_value text NOT NULL,
        creation_time text NOT NULL
      )"
    )
  end

  def insert_project_point_rows(integration, project_number, path_base, number_of_points) do
    rows =
      Enum.map(1..number_of_points, fn point_number ->
        %{
          point_name: "FAKE_POINT_#{point_number}",
          point_path: "#{path_base}#{point_number}",
          point_type: "AV"
        }
      end)

    PostgresPopulater.ProjectsRepo.insert_all(DatabaseTables.ProjectPoints, rows, prefix: "#{integration}_project_#{project_number}")
  end

  def insert_portfolio_project_rows(number_of_projects) do
    rows =
      Enum.map(["redis", "api"], fn integration_type ->
        Enum.map(1..number_of_projects, fn project_number ->
          %{
            project_name: "#{integration_type}_project_#{project_number}",
            integration_type: integration_type
          }
        end)
      end)
      |> List.flatten()
    PostgresPopulater.PortfolioRepo.insert_all(DatabaseTables.PortfolioProjectList, rows)
  end

  def truncate_rows(integration, project_number) do
    Ecto.Adapters.SQL.query!(
      PostgresPopulater.ProjectsRepo,
      "TRUNCATE #{integration}_project_#{project_number}.readings"
    )
  end

  def populate_api_points(number_of_projects, number_of_points) do
    Enum.each(1..number_of_projects, fn project_number ->
      create_project_schema_and_table("api", project_number)
      insert_project_point_rows("api", project_number, "801", number_of_points)
    end)
  end

  def populate_redis_points(number_of_projects, number_of_points) do
    Enum.each(1..number_of_projects, fn project_number ->
      create_project_schema_and_table("redis", project_number)
      insert_project_point_rows("redis", project_number, "FAKE_SYSTEM/FAKE_POINT_", number_of_points)
    end)
  end

  def truncate_all_readings(number_of_projects) do
    Enum.each(["redis", "api"], fn integration ->
      Enum.each(1..number_of_projects, fn project_number ->
        truncate_rows(integration, project_number)
      end)
    end)
  end

  def fill_database(number_of_projects, number_of_points) do
    create_portfolio_schemas()
    populate_portfolio(number_of_projects)
    populate_api_points(number_of_projects, number_of_points)
    populate_redis_points(number_of_projects, number_of_points)
  end
end
