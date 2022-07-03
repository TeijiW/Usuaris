defmodule Usuaris.Accounts.Update do
  alias Usuaris.{Account, Accounts, Addresses, Repo}

  def call(id, params) do
    with {:ok, %Account{} = account} <- Accounts.get(id) do
      address = Addresses.load_address_by_postal_code(params["address"])
      update_params = Map.put(params, "address", address)
      account |> Account.changeset(update_params) |> Repo.update()
    end
  end
end
