# Todo App

[![License][shield-license]][github]

> Todo App written in Elixir/Phoenix LiveView

This is a small todo app. User can create and update todo list and item for each list.
User can view site visitor count.

**Demo:**

[`https://todo-live-app.fly.dev/`](https://todo-live-app.fly.dev/)

<br>

## Setup

Following dependencies are required:

- Erlang 25.0+
- Elixir 1.13.4+
- Postgres

Compile Application and Assets(Auto):

```bash
$ mix do deps.get, compile
$ mix do ecto.setup
```

<br>

## Running

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
