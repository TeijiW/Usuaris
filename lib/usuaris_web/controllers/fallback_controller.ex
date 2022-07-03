defmodule UsuarisWeb.FallbackController do
  use UsuarisWeb, :controller
  alias Ecto.Changeset

  def call(conn, {:error, %Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> json(%{
      status: "Bad Request",
      errors: get_changeset_errors(changeset)
    })
  end

  def call(conn, {:error, :not_found}) do
    conn |> put_status(:not_found) |> json(status: "Not found")
  end

  defp get_changeset_errors(%Changeset{} = changeset) do
    Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
