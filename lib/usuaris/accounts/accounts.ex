defmodule Usuaris.Accounts do
  @moduledoc """
  Accounts context module
  """
  alias Usuaris.Accounts

  defdelegate list(params), to: Accounts.List, as: :call
  defdelegate create(params), to: Accounts.Create, as: :call
  defdelegate get(id), to: Accounts.Get, as: :call
  defdelegate delete(id), to: Accounts.Delete, as: :call
  defdelegate update(id, params), to: Accounts.Update, as: :call
end
