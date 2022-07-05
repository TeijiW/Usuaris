defmodule UsuarisWeb.AccountsControllerTest do
  use UsuarisWeb.ConnCase, async: false
  import Mock

  @address %{
    "bairro" => "Setor Leste (Vila Estrutural)",
    "cep" => "71261-155",
    "complemento" => "",
    "ddd" => "61",
    "gia" => "",
    "ibge" => "5300108",
    "localidade" => "Brasília",
    "logradouro" => "Quadra 2 Conjunto 11",
    "siafi" => "9701",
    "uf" => "DF"
  }

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

  describe "Get details from an account" do
    test "that exists", %{conn: conn} do
      inserted_account = insert(:account)

      assert response =
               conn |> get(accounts_path(conn, :show, inserted_account.id)) |> json_response(200)

      assert response["id"] == inserted_account.id
      assert response["name"] == inserted_account.name
      assert response["address"]["postal_code"] == inserted_account.address.postal_code
    end

    test "that not exists", %{conn: conn} do
      assert response = conn |> get(accounts_path(conn, :show, 123)) |> json_response(404)
      assert response["status"] == "Not Found"
    end
  end

  describe "Create an account" do
    test "with success", %{conn: conn} do
      create_params = %{
        "name" => "John Doe",
        "cpf" => Brcpfcnpj.cpf_generate(),
        "address" => %{"postal_code" => "71261151"}
      }

      assert response =
               conn |> post(accounts_path(conn, :create), create_params) |> json_response(201)

      assert response["name"] == "John Doe"
      assert response["address"]["postal_code"] == "71261151"
    end

    test "with error trying to use already used cpf", %{conn: conn} do
      cpf = Brcpfcnpj.cpf_generate()
      insert(:account, cpf: cpf)

      create_params = %{
        "name" => "John Doe",
        "cpf" => cpf,
        "address" => %{"postal_code" => "71261151"}
      }

      assert response =
               conn |> post(accounts_path(conn, :create), create_params) |> json_response(400)

      assert response["status"] == "Bad Request"
      assert response["errors"] == %{"cpf" => ["has already been taken"]}
    end

    test_with_mock "with error try loading all address by not found or invalid postal code",
                   %{conn: conn},
                   Tesla,
                   [],
                   execute: fn _, _, _ -> {:ok, %Tesla.Env{body: %{"erro" => "true"}}} end do
      create_params = %{
        "name" => "John Doe",
        "cpf" => Brcpfcnpj.cpf_generate(),
        "address" => %{"postal_code" => "78025"}
      }

      assert response =
               conn |> post(accounts_path(conn, :create), create_params) |> json_response(400)

      assert response["status"] == "Bad Request"

      assert response["errors"] == %{
               "address" => %{
                 "city" => ["can't be blank"],
                 "neighborhood" => ["can't be blank"],
                 "state" => ["can't be blank"],
                 "street" => ["can't be blank"]
               }
             }
    end
  end

  describe "Update an account" do
    setup do
      account = insert(:account)
      [account: account]
    end

    test "that exists", %{conn: conn, account: inserted_account} do
      update_params = %{
        "name" => "Updated John Foo Doe",
        "cpf" => inserted_account.cpf,
        "address" => %{
          city: "São Paulo",
          neighborhood: "Pinheiros",
          postal_code: "78040123",
          state: "SP",
          street: "Rua Inexistente"
        }
      }

      assert response =
               conn
               |> put(accounts_path(conn, :update, inserted_account.id), update_params)
               |> json_response(200)

      assert response["name"] == "Updated John Foo Doe"
      assert response["cpf"] == inserted_account.cpf
      assert response["address"]["postal_code"] == "78040123"
      assert response["address"]["state"] == "SP"
    end

    test "that exists with error trying update the cpf field", %{
      conn: conn,
      account: inserted_account
    } do
      update_params = %{
        "name" => "Updated John Foo Doe",
        "cpf" => Brcpfcnpj.cpf_generate(),
        "address" => %{
          city: "Cuiabá",
          neighborhood: "Santa Rosa",
          postal_code: "78040365",
          state: "MT",
          street: "Avenida Miguel Sutil"
        }
      }

      assert response =
               conn
               |> put(accounts_path(conn, :update, inserted_account.id), update_params)
               |> json_response(400)

      assert response["status"] == "Bad Request"
      assert response["errors"] == %{"cpf" => ["can't be updated"]}
    end
  end

  describe "Delete an account" do
    test "that exists", %{conn: conn} do
      inserted_account = insert(:account)

      assert response =
               conn
               |> delete(accounts_path(conn, :delete, inserted_account.id))
               |> response(200)

      assert response == ""
    end

    test "that not exists", %{conn: conn} do
      assert response = conn |> delete(accounts_path(conn, :delete, 123)) |> json_response(404)
      assert response["status"] == "Not Found"
    end
  end
end
