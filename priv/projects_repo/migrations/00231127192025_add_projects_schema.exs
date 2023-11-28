defmodule PostgresDataHandler.ProjectsRepo.Migrations.AddProjectsSchema do
  use Ecto.Migration

  def up do
    number_of_projects = String.to_integer(System.get_env("NUMBER_OF_PROJECTS"))
    integration_list = Jason.decode!(System.get_env("INTEGRATION_LIST"))
    Enum.map(integration_list, fn integration ->
      for project_number <- 1..number_of_projects do
        prefix = "#{integration}_project_#{project_number}"

        execute("CREATE SCHEMA #{prefix}")

        flush()
      end
    end)
  end

  def down do
    number_of_projects = String.to_integer(System.get_env("NUMBER_OF_PROJECTS"))
    integration_list = Jason.decode!(System.get_env("INTEGRATION_LIST"))
    Enum.map(integration_list, fn integration ->
      for project_number <- 1..number_of_projects do
        prefix = "#{integration}_project_#{project_number}"

        execute("DROP SCHEMA #{prefix}")

        flush()
      end
    end)
  end
end
