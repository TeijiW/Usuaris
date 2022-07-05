defmodule UsuarisWeb.AccountsControllerTest do
  use UsuarisWeb.ConnCase, async: false
  import Mock

  setup_with_mocks([
    {Tesla, [], [execute: fn _, _, _ -> {:ok, %Tesla.Env{body: @address, status: 200}} end]}
  ]) do
    :ok
  end

  describe "List all accounts" do
    setup do
      insert_list(5, :account)
      :ok
    end

    test "without query params", %{conn: conn} do
      assert response = conn |> get(accounts_path(conn, :index)) |> json_response(200)
      assert length(response) == 5
    end

    test "with limit query param", %{conn: conn} do
      assert response = conn |> get(accounts_path(conn, :index, limit: 3)) |> json_response(200)
      assert length(response) == 3
    end

    test "with offset query param", %{conn: conn} do
      assert response = conn |> get(accounts_path(conn, :index, offset: 4)) |> json_response(200)
      assert length(response) == 1
    end

    test "with limit and offset query params", %{conn: conn} do
      assert response =
               conn |> get(accounts_path(conn, :index, limit: 2, offset: 2)) |> json_response(200)

      assert length(response) == 2
    end
  end
end
