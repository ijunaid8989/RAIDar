defmodule ServerStatusWeb.API.RaidController do
  use ServerStatusWeb, :controller
  require Logger
  require IEx

  @check_raid_type "cat /proc/mdstat"
  @check_raid_ctrl "lspci | grep -i raid"

  def details_about_raid(conn, %{"ip" => ip, "username" => username, "password" => password} = _params) do
    connect_to_server(ip, username, password)
    |> check_status_for_server()
    |> still_in_pipe_operate(conn)
  end

  defp still_in_pipe_operate({message, :error}, conn), do: conn |> put_status(400) |> json(%{message: message})
  defp still_in_pipe_operate({true, connected}, conn) do
    connected
    |> run_command_on_server(@check_raid_type)
    |> respond_with_type()
    |> continue_if_hard(conn, connected)
  end

  defp continue_if_hard("soft", conn, _connected), do: conn |> put_status(404) |> json(%{message: "We dont care about Software Raid.", hardware: false})
  defp continue_if_hard("hard", conn, connected) do
    connected
    |> run_command_on_server(@check_raid_ctrl)
    |> respond_with_ctrl(conn)
  end

  defp respond_with_ctrl("02:00.0 RAID bus controller: " <> controller, conn) do
    conn
    |> put_status(201)
    |> json(%{message: controller, hardware: true, man: get_man_raid(controller)})
  end

  defp get_man_raid(controller) do
    cond do
      controller =~ "MegaRAID"  == true -> "megaRaid"
      controller =~ "Adaptec"   == true -> "Adaptec"
      true -> "Unknown"
    end
  end

  defp respond_with_type(res) do
    check_md_soft(res =~ "md")
  end

  defp check_md_soft(true), do: "soft"
  defp check_md_soft(false), do: "hard"

  defp run_command_on_server(conn, command) do
    conn
    |> SSHEx.run(command)
    |> response_is
  end

  defp response_is({:ok, res, 0}), do: res
  defp response_is({:error, reason}), do: reason

  defp check_status_for_server({:error, :nxdomain}), do: {"IP doesn't seem correct.", :error}
  defp check_status_for_server({:error, :timeout}), do: {"Server is giving timeout.", :error}
  defp check_status_for_server({:error, reason}), do: {reason, :error}
  defp check_status_for_server({:ok, connection}), do: {true, connection}

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
          password: password,
          raid_type: raid_type,
          raid_man: raid_man
        } = server

        conn
        |> put_status(:created)
        |> json(%{
          "name" => name,
          "username" => username,
          "password" => password,
          "ip" => ip,
          "raid_type" => raid_type,
          "raid_man" => raid_man
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
          raid_man: server.raid_man,
          extra: server.extra,
          password: server.password
        }
      end)
    conn
    |> put_status(200)
    |> json(raid_servers)
  end
end
