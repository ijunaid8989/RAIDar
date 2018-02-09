defmodule ServerStatus.Evercam do
  import Ecto.Query, warn: false
  alias ServerStatus.Repo
  alias ServerStatus.Evercam.User
  alias ServerStatus.Evercam.Server
  require Logger

  def parse_changeset(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn
      {msg, opts} -> String.replace(msg, "%{count}", to_string(opts[:count]))
      msg -> msg
    end)
  end

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

  def list_servers do
    Repo.all(Server)
  end

  def get_server!(id), do: Repo.get!(Server, id)

  def create_server(attrs \\ %{}) do
    %Server{}
    |> Server.changeset(attrs)
    |> Repo.insert()
  end

  def update_server(%Server{} = server, attrs) do
    server
    |> Server.changeset(attrs)
    |> Repo.update()
  end

  def delete_server(%Server{} = server) do
    Repo.delete(server)
  end

  def change_server(%Server{} = server) do
    Server.changeset(server, %{})
  end
end
