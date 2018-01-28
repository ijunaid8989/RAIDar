defmodule ServerStatus.Evercam do
  import Ecto.Query, warn: false
  alias ServerStatus.Repo

  alias ServerStatus.Evercam.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_email!(email) do
    User
    |> where(email: ^email)
    |> Repo.one
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Repo.get(User, id)
  end

  def authenticate(%{"email" => email, "password" => password}) do
    get_user_email!(email)
    |> case do
      nil -> false
      %User{} = user -> {Comeonin.Bcrypt.checkpw(password, user.password), user}
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias ServerStatus.Evercam.Raid

  def list_raids do
    Repo.all(Raid)
  end

  def get_raid!(id), do: Repo.get!(Raid, id)

  def create_raid(attrs \\ %{}) do
    %Raid{}
    |> Raid.changeset(attrs)
    |> Repo.insert()
  end

  def update_raid(%Raid{} = raid, attrs) do
    raid
    |> Raid.changeset(attrs)
    |> Repo.update()
  end

  def delete_raid(%Raid{} = raid) do
    Repo.delete(raid)
  end

  def change_raid(%Raid{} = raid) do
    Raid.changeset(raid, %{})
  end
end
