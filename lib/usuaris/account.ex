defmodule Usuaris.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Brcpfcnpj.Changeset
  alias Usuaris.Account.Address

  @fields [:name, :cpf]

  schema "accounts" do
    field :name, :string
    field :cpf, :string
    embeds_one :address, Address

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account \\ %__MODULE__{}, attrs) do
    account
    |> cast(attrs, @fields)
    |> cast_embed(:address, required: true)
    |> validate_cpf(:cpf)
    |> unique_constraint(:cpf)
    |> validate_required(@fields)
  end
end
