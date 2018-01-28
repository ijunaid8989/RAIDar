defmodule ServerStatusWeb.API.RaidController do
  use ServerStatusWeb, :controller
  require Logger

  @check_raid_type "cat /proc/mdstat"

  def details_about_raid(conn, %{"ip" => ip, "username" => username, "password" => password} = _params) do
    connect_to_server(ip, username, password)
    |> check_status_for_server(conn)
  end

  defp check_status_for_server({:error, :nxdomain}, conn), do: conn |> put_status(400) |> json(%{message: "IP doesn't seem correct."})
  defp check_status_for_server({:error, :timeout}, conn), do: conn |> put_status(400) |> json(%{message: "Server is giving timeout."})
  defp check_status_for_server({:error, reason}, conn), do: conn |> put_status(400) |> json(%{message: reason})
  defp check_status_for_server({:ok, connection}, _conn), do: connection

  defp connect_to_server(ip, username, password), do:
    SSHEx.connect(ip: ip, user: username, password: password)

  def create_raid(conn, params) do
    params
    |> ServerStatus.Evercam.create_raid()
    |> case do
      {:ok, server} ->
        Logger.info "Added server for Raid"
        %ServerStatus.Evercam.Raid{
          id: _id,
          name: name,
          ip: ip,
          username: username,
          password: password
        } = server

        conn
        |> put_status(:created)
        |> json(%{
          "name" => name,
          "username" => username,
          "password" => password,
          "ip" => ip,
        })

      {:error, changeset} ->
        errors = ServerStatus.Evercam.parse_changeset(changeset)
        traversed_errors = for {_key, values} <- errors, value <- values, do: "#{value}"
        conn
        |> put_status(400)
        |> json(%{ errors: traversed_errors }) 
    end
  end

  def load_raid_servers(conn, _params) do
    raid_servers = 
      ServerStatus.Evercam.list_raids()
      |> Enum.map(fn(server) ->
        %{
          id: server.id,
          name: server.name,
          ip: server.ip,
          username: server.username,
          raid_type: server.raid_type,
          password: server.password
        }
      end)
    conn
    |> put_status(200)
    |> json(raid_servers)
  end
end
