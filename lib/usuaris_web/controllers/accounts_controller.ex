defmodule UsuarisWeb.AccountsController do
  use UsuarisWeb, :controller
  alias Usuaris.{Account, Accounts}

  action_fallback UsuarisWeb.FallbackController

  def index(conn, params) do
    accounts = Accounts.list(params)
    json(conn, accounts)
  end

  def show(conn, %{"id" => account_id} = _params) do
    with {:ok, %Account{} = account} <- Accounts.get(account_id) do
      json(conn, account)
    end
  end

  def create(conn, params) do
    with {:ok, %Account{} = account} <- Accounts.create(params) do
      conn |> put_status(:created) |> json(account)
    end
  end

  def update(conn, %{"id" => account_id} = params) do
    with {:ok, %Account{} = updated_account} <- Accounts.update(account_id, params) do
      json(conn, updated_account)
    end
  end

  def delete(conn, %{"id" => account_id} = _params) do
    with {:ok, %Account{} = _deleted_account} <- Accounts.delete(account_id) do
      conn
      |> Plug.Conn.send_resp(200, [])
      |> Plug.Conn.halt()
    end
  end
end
