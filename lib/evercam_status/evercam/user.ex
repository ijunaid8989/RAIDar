defmodule ServerStatus.Evercam.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ServerStatus.Evercam.User


  schema "users" do
    field :email, :string
    field :is_employee, :boolean, default: false
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :is_employee])
    |> validate_required([:email, :password, :is_employee])
  end
end
