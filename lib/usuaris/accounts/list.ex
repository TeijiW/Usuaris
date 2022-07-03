defmodule Usuaris.Accounts.List do
  import Ecto.Query, only: [offset: 3, limit: 3]
  alias Usuaris.{Account, Repo}

  def call(params) do
    Account |> handle_limit(params["limit"]) |> handle_offset(params["offset"]) |> Repo.all()
  end

  defp handle_limit(query, nil), do: query
  defp handle_limit(query, limit), do: limit(query, [], ^limit)

  defp handle_offset(query, nil), do: query
  defp handle_offset(query, offset), do: offset(query, [], ^offset)
end
