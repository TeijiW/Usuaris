defmodule Usuaris.Accounts.Get do
  alias Usuaris.{Account, Repo}
  def call(id), do: Repo.get(Account, id)
end
