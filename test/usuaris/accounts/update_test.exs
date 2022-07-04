defmodule Usuaris.Accounts.UpdateTest do
  use Usuaris.DataCase, async: false
  import Mock
  alias Usuaris.Accounts.Update

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

  describe "call/1" do
    setup do
      account = insert(:account)
      [account: account]
    end

    test "with success loading all address by postal code", %{account: inserted_account} do
      update_params = %{
        "name" => "Updated John Foo Doe",
        "cpf" => inserted_account.cpf,
        "address" => %{"postal_code" => "71261151"}
      }

      assert {:ok, updated_account} = Update.call(inserted_account.id, update_params)
      assert updated_account.name == "Updated John Foo Doe"
      assert updated_account.cpf == inserted_account.cpf
      assert updated_account.address.postal_code == "71261151"
    end

    test "with success loading some address fields of address by postal code", %{
      account: inserted_account
    } do
      update_params = %{
        "name" => "Updated John Foo Doe",
        "cpf" => inserted_account.cpf,
        "address" => %{"postal_code" => "71261151", "city" => "São Paulo", "state" => "SP"}
      }

      assert {:ok, updated_account} = Update.call(inserted_account.id, update_params)
      assert updated_account.name == "Updated John Foo Doe"
      assert updated_account.cpf == inserted_account.cpf
      assert updated_account.address.postal_code == "71261151"
      assert updated_account.address.state == "SP"
    end

    test_with_mock "with success keep inserted address when get new address by postal code returns not found",
                   %{account: inserted_account},
                   Tesla,
                   [],
                   execute: fn _, _, _ -> {:ok, %Tesla.Env{body: %{"erro" => "true"}}} end do
      update_params = %{
        "name" => "Update Jana Doe",
        "cpf" => inserted_account.cpf,
        "address" => %{"postal_code" => "71261151"}
      }

      assert {:ok, updated_account} = Update.call(inserted_account.id, update_params)

      assert updated_account.name == "Update Jana Doe"
      assert updated_account.cpf == inserted_account.cpf
      assert updated_account.address.street == inserted_account.address.street
      assert updated_account.address.state == inserted_account.address.state
    end

    test_with_mock "with success keep inserted address when get new address by postal code returns invalid",
                   %{account: inserted_account},
                   Tesla,
                   [],
                   execute: fn _, _, _ -> {:ok, %Tesla.Env{status: 400}} end do
      update_params = %{
        "name" => "Update Jana Doe",
        "cpf" => inserted_account.cpf,
        "address" => %{"postal_code" => "71261151"}
      }

      assert {:ok, updated_account} = Update.call(inserted_account.id, update_params)

      assert updated_account.name == "Update Jana Doe"
      assert updated_account.cpf == inserted_account.cpf
      assert updated_account.address.street == inserted_account.address.street
      assert updated_account.address.state == inserted_account.address.state
    end

    test "with error update cpf is not allowed", %{account: inserted_account} do
      update_params = %{
        "name" => inserted_account.name,
        "cpf" => Brcpfcnpj.cpf_generate(),
        "address" => %{"postal_code" => "71261151"}
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Update.call(inserted_account.id, update_params)

      assert changeset.errors == [cpf: {"can't be updated", []}]
    end
  end
end
