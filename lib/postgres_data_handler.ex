defmodule PostgresDataHandler do

  ### Main Populater
  def fill_database() do
    %{
      integration_list: integration_list,
      number_of_projects: number_of_projects,
      number_of_points: number_of_points
    } = get_envs()

    populate_portfolio_project_list(integration_list, number_of_projects)
    populate_api_points(number_of_projects, number_of_points)
    populate_redis_points(number_of_projects, number_of_points)
  end

  ### Portfolio Schema Section

  def populate_portfolio_project_list(integration_list, number_of_projects) do
    rows =
      Enum.map(integration_list, fn integration_type ->
        Enum.map(1..number_of_projects, fn project_number ->
          %{
            project_name: "#{integration_type}_project_#{project_number}",
            integration_type: integration_type,
            source: "127.0.0.1"
          }
        end)
      end)
      |> List.flatten()

    PostgresDataHandler.PortfolioRepo.insert_all(DatabaseTables.PortfolioProjectList, rows)
  end

  ### Projects Schema Section

  def populate_api_points(number_of_projects, number_of_points) do
    Enum.each(1..number_of_projects, fn project_number ->
      insert_project_point_rows("api", project_number, "801", number_of_points)
    end)
  end

  def populate_redis_points(number_of_projects, number_of_points) do
    Enum.each(1..number_of_projects, fn project_number ->
      insert_project_point_rows(
        "redis",
        project_number,
        "FAKE_SYSTEM/FAKE_POINT_",
        number_of_points
      )
    end)
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

    PostgresDataHandler.ProjectsRepo.insert_all(DatabaseTables.ProjectPoints, rows,
      prefix: "#{integration}_project_#{project_number}"
    )
  end

  ### Clean-up/Reset Section
  def truncate_all_readings() do
    %{
      integration_list: integration_list,
      number_of_projects: number_of_projects
    } = get_envs()

    Enum.each(integration_list, fn integration ->
      Enum.each(1..number_of_projects, fn project_number ->
        truncate_rows(integration, project_number)
      end)
    end)
  end

  def truncate_rows(integration, project_number) do
    Ecto.Adapters.SQL.query!(
      PostgresDataHandler.ProjectsRepo,
      "TRUNCATE #{integration}_project_#{project_number}.readings"
    )
  end

  ### Helper Functions

  def get_envs() do
    integration_list = Jason.decode!(System.get_env("INTEGRATION_LIST"))
    number_of_projects = String.to_integer(System.get_env("NUMBER_OF_PROJECTS"))
    number_of_points = String.to_integer(System.get_env("NUMBER_OF_POINTS"))

    %{
      integration_list: integration_list,
      number_of_projects: number_of_projects,
      number_of_points: number_of_points
    }
  end
end
