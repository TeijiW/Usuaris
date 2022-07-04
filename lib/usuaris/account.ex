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
    |> only_numbers(:cpf)
    |> ignore_cpf_change_on_update()
    |> validate_cpf(:cpf)
    |> unique_constraint(:cpf)
    |> validate_required(@fields)
  end

  defp only_numbers(changeset, field) do
    field_value = get_field(changeset, field)
    field_new_value = String.replace(field_value, ~r/[^\d]/, "")
    put_change(changeset, field, field_new_value)
  end

  defp ignore_cpf_change_on_update(changeset) do
    cpf_update = get_change(changeset, :cpf, nil)
    current_cpf = changeset.data.cpf

    if cpf_update != current_cpf && not is_nil(current_cpf),
      do: put_change(changeset, :cpf, current_cpf),
      else: changeset
  end
end
