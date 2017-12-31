defmodule ServerStatusWeb.PageController do
  use ServerStatusWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
