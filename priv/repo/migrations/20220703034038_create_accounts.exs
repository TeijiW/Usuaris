defmodule Usuaris.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :cpf, :string
      add :address, :map

      timestamps()
    end

    create index(:accounts, [:cpf], unique: true)
  end
end
