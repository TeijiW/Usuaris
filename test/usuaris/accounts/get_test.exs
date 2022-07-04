defmodule Usuaris.Accounts.GetTest do
  use Usuaris.DataCase, async: true
  alias Usuaris.Accounts.Get

  describe "call/1" do
    test "get an account" do
      inserted_account = insert(:account)
      assert {:ok, result} = Get.call(inserted_account.id)
      assert result.name == inserted_account.name
      assert result.cpf == inserted_account.cpf
    end

    test "not found" do
      assert {:error, :not_found} = Get.call(123)
    end
  end
end
