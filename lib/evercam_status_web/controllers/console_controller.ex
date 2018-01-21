defmodule ServerStatusWeb.ConsoleController do
  use ServerStatusWeb, :controller
  alias ServerStatus.Evercam.User

  def index(conn, _params) do
    render conn, "console.html"
  end
end
