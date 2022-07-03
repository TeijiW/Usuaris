defmodule Usuaris.Accounts.Create do
  alias Usuaris.{Account, Repo}

  def call(params) do
    params |> Account.changeset() |> Repo.insert()
  end
end
