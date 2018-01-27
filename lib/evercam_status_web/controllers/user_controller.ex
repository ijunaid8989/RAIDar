defmodule ServerStatusWeb.UserController do
  use ServerStatusWeb, :controller

  def index(conn, _params) do
    render conn, "sign_in.html", csrf_token: get_csrf_token()
  end

  def create(conn, params) do
    case ServerStatus.Evercam.authenticate(params) do
      {true, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "You have logged in.")
        |> redirect(to: "/console")
      false ->
        conn
        |> put_flash(:error_email, "No account related to this email.")
        |> redirect(to: "/")
      {false, _user} ->
        conn
        |> put_flash(:error_password, "Password is so wrong.")
        |> redirect(to: "/")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
