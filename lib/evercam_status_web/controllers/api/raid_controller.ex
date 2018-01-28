defmodule ServerStatusWeb.API.RaidController do
  use ServerStatusWeb, :controller

  def detect_raid(conn, params) do
    conn
    |> json(%{message: "hello"})    
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
