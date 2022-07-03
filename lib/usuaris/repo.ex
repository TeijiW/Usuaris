defmodule Usuaris.Repo do
  use Ecto.Repo,
    otp_app: :usuaris,
    adapter: Ecto.Adapters.Postgres
end
