defmodule Usuaris.Integrations.Viacep do
  use Tesla
  plug Tesla.Middleware.BaseUrl, "https://viacep.com.br"
  plug Tesla.Middleware.JSON

  def get_postal_code_details(postal_code) do
    get("/ws/#{postal_code}/json") |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{body: %{"erro" => "true"}}}),
    do: {:error, :not_found}

  defp handle_response({:ok, %Tesla.Env{status: 400}}),
    do: {:error, :invalid}

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}),
    do: {:ok, body}

  defp handle_response(response), do: response
end
