defmodule UsuarisWeb.AccountsController do
  use UsuarisWeb, :controller
  alias Usuaris.{Account, Accounts}

  def index(conn, params) do
    accounts = Accounts.list(params)
    json(conn, accounts)
  end

  def show(conn, %{"id" => account_id} = _params) do
    with {:ok, %Account{} = account} <- Accounts.get(account_id) do
      json(conn, account)
    end
  end
end
