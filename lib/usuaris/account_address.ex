defmodule Usuaris.Account.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @optional_fields [:number, :complement]
  @required_fields [:street, :neighborhood, :city, :state, :postal_code]

  embedded_schema do
    field :street, :string
    field :number, :string
    field :complement, :string
    field :neighborhood, :string
    field :city, :string
    field :state, :string
    field :postal_code, :string
  end

  def changeset(address, attrs \\ %{}) do
    address
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
