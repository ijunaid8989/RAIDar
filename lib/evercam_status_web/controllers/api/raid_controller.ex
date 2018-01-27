defmodule API.RaidController do
  use ServerStatusWeb, :controller

  def detect_raid(conn, params) do
    conn
    |> json(%{message: "hello"})    
  end
end