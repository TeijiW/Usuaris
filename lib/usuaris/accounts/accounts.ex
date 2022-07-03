defmodule Usuaris.Accounts do
  @moduledoc """
  Accounts context module
  """
  alias Usuaris.Accounts

  defdelegate create(params), to: Accounts.Create, as: :call
end
