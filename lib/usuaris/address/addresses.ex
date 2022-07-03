defmodule Usuaris.Addresses do
  @moduledoc """
  Addresses context module
  """
  alias Usuaris.Addresses

  defdelegate load_address_by_postal_code(address_params),
    to: Addresses.LoadByPostalCode,
    as: :call
end
