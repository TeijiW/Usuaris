defmodule Usuaris.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Brcpfcnpj.Changeset
  alias Usuaris.Account.Address

  @derive {Jason.Encoder, except: [:__meta__]}

  @fields [:name, :cpf]

  schema "accounts" do
    field :name, :string
    field :cpf, :string
    embeds_one :address, Address, on_replace: :update

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account \\ %__MODULE__{}, attrs) do
    account
    |> cast(attrs, @fields)
    |> cast_embed(:address, required: true, with: &Address.changeset/2)
    |> ignore_cpf_when_update()
    |> validate_cpf(:cpf)
    |> unique_constraint(:cpf)
    |> validate_required(@fields)
  end

  defp ignore_cpf_when_update(changeset) do
    cpf_update = get_change(changeset, :cpf, nil)
    current_cpf = changeset.data.cpf

    if cpf_update != current_cpf && not is_nil(current_cpf),
      do: put_change(changeset, :cpf, current_cpf),
      else: changeset
  end
end
