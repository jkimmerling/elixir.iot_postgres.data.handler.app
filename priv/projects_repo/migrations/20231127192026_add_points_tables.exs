defmodule PostgresDataHandler.ProjectsRepo.Migrations.AddPointsTables do
  use Ecto.Migration

  def up do
    number_of_projects = String.to_integer(System.get_env("NUMBER_OF_PROJECTS"))
    integration_list = Jason.decode!(System.get_env("INTEGRATION_LIST"))
    Enum.map(integration_list, fn integration ->
      for project_number <- 1..number_of_projects do
        prefix = "#{integration}_project_#{project_number}"

        create table(:points, prefix: prefix) do
          add :point_name, :string
          add :point_path, :string
          add :point_type, :string
        end

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

        # drop table(:points, prefix: prefix)
        execute("DROP TABLE #{prefix}.points")

        flush()
      end
    end)
  end
end
