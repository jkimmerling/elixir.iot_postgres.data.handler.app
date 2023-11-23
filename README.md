# PostgresPopulater

## Description

This is some "quick and dirty" elixir code to populate the Postgres database used in the overall "Elixir IoT" project.

## Postgres Docker

Start the Postgres container using this:
```
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```

If you change the username and password, remember to change them in config/config.exs