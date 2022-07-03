defmodule Usuaris.Accounts.Create do
  alias Usuaris.{Account, Addresses, Repo}

  def call(params) do
    address = Addresses.load_address_by_postal_code(params["address"])

    params
    |> Map.put("address", address)
    |> Account.changeset()
    |> Repo.insert()
  end
end
