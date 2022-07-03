defmodule Usuaris.Accounts.Create do
  alias Usuaris.{Account, Integrations, Repo}

  def call(params) do
    address = load_address_by_postal_code(params)

    params
    |> Map.put("address", address)
    |> Account.changeset()
    |> Repo.insert()
  end

  defp load_address_by_postal_code(
         %{"address" => %{"postal_code" => postal_code} = raw_address} = _params
       ) do
    with {:ok, data} <- Integrations.Viacep.get_postal_code_details(postal_code) do
      data
      |> parse_postal_code_data()
      |> replace_empty_address_fields(raw_address)
    else
      _error -> raw_address
    end
  end

  defp replace_empty_address_fields(parsed_address, raw_address) do
    Account.Address.fields()
    |> Enum.map(&get_address_field(&1, parsed_address, raw_address))
    |> Map.new()
  end

  defp parse_postal_code_data(data) do
    %{
      "street" => data["logradouro"],
      "neighborhood" => data["bairro"],
      "city" => data["localidade"],
      "state" => data["uf"]
    }
  end

  defp get_address_field(field, parsed_address, raw_address) do
    raw_value = raw_address[field]
    parsed_value = parsed_address[field]

    value =
      if is_nil(raw_value) || String.trim(raw_value) == "", do: parsed_value, else: raw_value

    {field, value}
  end
end
