defmodule Usuaris.Accounts.CreateTest do
  use Usuaris.DataCase, async: false
  import Mock
  alias Usuaris.Accounts.Create

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

  describe "call/1" do
    test_with_mock "with success load all address by postal code", Tesla,
      execute: fn _, _, _ -> {:ok, %Tesla.Env{body: @address, status: 200}} end do
      create_params = %{
        "name" => "John Doe",
        "cpf" => Brcpfcnpj.cpf_generate(),
        "address" => %{"postal_code" => "71261151"}
      }

      assert {:ok, inserted_account} = Create.call(create_params)
      assert inserted_account.name == "John Doe"
      assert inserted_account.address.postal_code == "71261151"
    end

    test_with_mock "with success load some fields of address by postal code", Tesla,
      execute: fn _, _, _ -> {:ok, %Tesla.Env{body: @address, status: 200}} end do
      create_params = %{
        "name" => "John Doe",
        "cpf" => Brcpfcnpj.cpf_generate(),
        "address" => %{"postal_code" => "71261151", "city" => "São Paulo", "state" => "SP"}
      }

      assert {:ok, inserted_account} = Create.call(create_params)
      assert inserted_account.name == "John Doe"
      assert inserted_account.address.postal_code == "71261151"
      assert inserted_account.address.state == "SP"
    end

    test_with_mock "with error try load all address by not found postal code", Tesla,
      execute: fn _, _, _ -> {:ok, %Tesla.Env{body: %{"erro" => "true"}}} end do
      create_params = %{
        "name" => "John Doe",
        "cpf" => Brcpfcnpj.cpf_generate(),
        "address" => %{"postal_code" => "71261151"}
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Create.call(create_params)

      assert changeset.changes.address.errors == [
               street: {"can't be blank", [validation: :required]},
               neighborhood: {"can't be blank", [validation: :required]},
               city: {"can't be blank", [validation: :required]},
               state: {"can't be blank", [validation: :required]}
             ]
    end

    test_with_mock "with error try load some address fields by not found postal code", Tesla,
      execute: fn _, _, _ -> {:ok, %Tesla.Env{body: %{"erro" => "true"}}} end do
      create_params = %{
        "name" => "John Doe",
        "cpf" => Brcpfcnpj.cpf_generate(),
        "address" => %{
          "postal_code" => "71261151",
          "street" => "Rua Getúlio Vargas",
          "neighborhood" => "Porto"
        }
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Create.call(create_params)

      assert changeset.changes.address.errors == [
               city: {"can't be blank", [validation: :required]},
               state: {"can't be blank", [validation: :required]}
             ]
    end

    test_with_mock "with error try load all address by invalid postal code", Tesla,
      execute: fn _, _, _ -> {:ok, %Tesla.Env{status: 400}} end do
      create_params = %{
        "name" => "John Doe",
        "cpf" => Brcpfcnpj.cpf_generate(),
        "address" => %{"postal_code" => "71261151"}
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Create.call(create_params)

      assert changeset.changes.address.errors == [
               street: {"can't be blank", [validation: :required]},
               neighborhood: {"can't be blank", [validation: :required]},
               city: {"can't be blank", [validation: :required]},
               state: {"can't be blank", [validation: :required]}
             ]
    end

    test_with_mock "with error try load some address fields by invalid postal code", Tesla,
      execute: fn _, _, _ -> {:ok, %Tesla.Env{status: 400}} end do
      create_params = %{
        "name" => "John Doe",
        "cpf" => Brcpfcnpj.cpf_generate(),
        "address" => %{
          "postal_code" => "71261151",
          "street" => "Rua Getúlio Vargas",
          "neighborhood" => "Porto"
        }
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Create.call(create_params)

      assert changeset.changes.address.errors == [
               city: {"can't be blank", [validation: :required]},
               state: {"can't be blank", [validation: :required]}
             ]
    end
  end
end
