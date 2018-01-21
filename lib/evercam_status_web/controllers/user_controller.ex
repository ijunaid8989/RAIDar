defmodule ServerStatusWeb.UserController do
  use ServerStatusWeb, :controller

  def index(conn, _params) do
    render conn, "sign_in.html", csrf_token: get_csrf_token()
  end
end
