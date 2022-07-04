defmodule Usuaris.Accounts.ListTest do
  use Usuaris.DataCase, async: true
  alias Usuaris.Account
  alias Usuaris.Accounts.List

  describe "call/1" do
    test "list all without params" do
      insert_list(3, :account)
      assert [_ | _] = list = List.call(%{})
      assert length(list) == 3
    end

    test "list all with limit param" do
      insert_list(4, :account)
      assert [_ | _] = list = List.call(%{"limit" => 3})
      assert length(list) == 3
    end

    test "list all with offset param" do
      insert_list(3, :account)
      assert [%Account{} = _account] = List.call(%{"offset" => 2})
    end

    test "list all with limit and offset param" do
      insert_list(4, :account)
      assert [%Account{} = _account] = List.call(%{"offset" => 2, "limit" => 1})
    end
  end
end
