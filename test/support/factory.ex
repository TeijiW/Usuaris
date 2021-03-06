defmodule Support.Factory do
  use ExMachina.Ecto, repo: Usuaris.Repo

  def account_factory do
    %Usuaris.Account{
      name: sequence(:name, &"John Doe #{&1}"),
      cpf: Brcpfcnpj.cpf_generate(),
      address: %{
        city: "Cuiabá",
        neighborhood: "Santa Rosa",
        postal_code: "78040365",
        state: "MT",
        street: "Avenida Miguel Sutil"
      }
    }
  end
end
