defmodule Usuaris.Accounts do
  @moduledoc """
  Accounts context module
  """
  alias Usuaris.{Account, Accounts, Integrations}

  defdelegate create(params), to: Accounts.Create, as: :call
  defdelegate get(id), to: Accounts.Get, as: :call
  defdelegate update(id, params), to: Accounts.Update, as: :call
end
