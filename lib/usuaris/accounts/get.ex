defmodule Usuaris.Accounts.Get do
  alias Usuaris.{Account, Repo}

  def call(id) do
    case Repo.get(Account, id) do
      %Account{} = account -> {:ok, account}
      nil -> {:error, :not_found}
    end
  end
end
