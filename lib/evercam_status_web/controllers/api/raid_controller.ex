defmodule ServerStatusWeb.API.RaidController do
  use ServerStatusWeb, :controller
  require Logger

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

        ServerStatus.Evercam.detect_raid_on_server(server)

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
