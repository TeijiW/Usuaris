defmodule Usuaris.Accounts.Delete do
  alias Usuaris.{Account, Accounts, Repo}

  def call(id) do
    with %Account{} = account <- Accounts.get(id) do
      Repo.delete(account)
    end
  end
end
