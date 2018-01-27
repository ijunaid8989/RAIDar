defmodule ServerStatusWeb.ConsoleController do
  use ServerStatusWeb, :controller

  def index(conn, _params) do
    render conn, "console.html"
  end

  def raid(conn, _params) do
    render conn, "console.html"
  end
end
