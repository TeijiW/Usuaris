# Usuaris
A basic and small Rest API with CRUD of User Accounts

## To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Docs
The documentation of this API is available on [Postman](https://documenter.getpostman.com/view/6551338/UzJHPxMZ)

## Improvements
Improvements that can be done to make this API more scalable, resilient and robust
- Optimize the insert and update account operations to call _Viacep_ integration if the changeset is valid
- Create table for addresses instead of use a JSONB column and Embedded Schema
- Change from `Mock` package to `Mox`
- Create a template called `error.json` as pattern for errors