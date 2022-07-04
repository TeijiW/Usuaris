defmodule Usuaris.Accounts.DeleteTest do
  use Usuaris.DataCase, async: true
  alias Usuaris.Account
  alias Usuaris.Accounts.Delete

  describe "call/1" do
    test "with success" do
      account = insert(:account)
      assert {:ok, %Account{}} = Delete.call(account.id)
    end

    test "not found" do
      assert {:error, :not_found} = Delete.call(311)
    end
  end
end
