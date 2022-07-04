defmodule Usuaris.Addresses.LoadByPostalCode do
  alias Usuaris.{Account, Integrations}

  def call(%{"postal_code" => postal_code} = address_params) do
    with {:ok, data} <- Integrations.Viacep.get_postal_code_details(postal_code) do
      data
      |> parse_postal_code_data()
      |> replace_empty_address_fields(address_params)
    else
      _error -> address_params
    end
  end

  def call(address_params), do: address_params

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
