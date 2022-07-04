defmodule UsuarisWeb.AccountsController do
  use UsuarisWeb, :controller
  alias Usuaris.Accounts

  def index(conn, params) do
    accounts = Accounts.list(params)
    json(conn, accounts)
  end
end
