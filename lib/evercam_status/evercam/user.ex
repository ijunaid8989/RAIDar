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

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, hash_password(password))
      _ ->
        changeset
    end
  end

  def hash_password(password) do
    Comeonin.Bcrypt.hashpass(password, Comeonin.Bcrypt.gen_salt(12, true))
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :is_employee])
    |> validate_required([:email, :password, :is_employee])
    |> encrypt_password
  end
end
