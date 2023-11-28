# Postgres Data Handler

## Description

This is an app used to populate the Postgres database used in the overall "Elixir IoT" project.

## Configuration

The configuration variables will be set in the `set_envs.sh` shell script

The configuration variables that need to be filled out:  
 * `PORTFOLIO_DB_USERNAME` - The username for the `portfolio` database, if using the supplied docker containter command, this should be the same between both databases.
 * `PORTFOLIO_DB_PASSWORD` - The password for the `portfolio` database, if using the supplied docker containter command, this should be the same between both databases.
 * `PORTFOLIO_DB_HOSTNAME` - The hostname for the `portfolio` database, if using the supplied docker containter command, this should be the same between both databases.
 * `PROJECTS_DB_USERNAME` - The username for the `projects` database, if using the supplied docker containter command, this should be the same between both databases.
 * `PROJECTS_DB_PASSWORD` - The password for the `projects` database, if using the supplied docker containter command, this should be the same between both databases.
 * `PROJECTS_DB_HOSTNAME` - The hostname for the `projects` database, if using the supplied docker containter command, this should be the same between both databases.
 * `NUMBER_OF_PROJECTS` - The number of projects PER integration to create
 * `NUMBER_OF_POINTS` - The number of points PER project to create
 * `INTEGRATION_LIST` - The list of integrations to create projects/points for. This needs to be formatted as a string list.

## How to run it

### Via IEx
The steps below assume you have the following installed on your system :  
 * `Elixir` version `1.14` or higher  
 * `Erlang` with `OTP` version `24` or higher  
  
Steps to run it via `iex`:
 1. Clone the repo
 2. Start the postgres docker container by running:  
   `docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres`
   The username and password need to match what is used in the `set_envs.sh` shell script
 3. Set the variables in `set_envs.sh`
 4. run `chmod +x set_envs.sh` - this only needs to be done once
 5. run `. ./set_envs.sh`
 6. run `mix deps.get`
 7. run `mix ecto.create` - this creates the databases
 8. run `mix ecto.migrate` - this creates the schemas and tables
 9.  run `iex -S mix`
 10. run `PostgresDataHandler.fill_database()`