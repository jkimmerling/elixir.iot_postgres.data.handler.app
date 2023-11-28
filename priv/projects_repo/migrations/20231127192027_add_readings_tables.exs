defmodule PostgresDataHandler.ProjectsRepo.Migrations.AddReadingsTables do
  use Ecto.Migration

  def up do
    number_of_projects = String.to_integer(System.get_env("NUMBER_OF_PROJECTS"))
    integration_list = Jason.decode!(System.get_env("INTEGRATION_LIST"))
    Enum.map(integration_list, fn integration ->
      for project_number <- 1..number_of_projects do
        prefix = "#{integration}_project_#{project_number}"

        create table(:readings, prefix: prefix) do
          add :point_id, :integer
          add :point_name, :string
          add :point_path, :string
          add :point_value, :string
          timestamps()
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

        # drop table(:readings, prefix: prefix)
        execute("DROP TABLE #{prefix}.readings")

        flush()
      end
    end)
  end
end
