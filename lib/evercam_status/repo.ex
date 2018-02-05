defmodule ServerStatus.Repo do
  use Ecto.Repo, otp_app: :evercam_status

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    start_ets_connection()
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def start_ets_connection do
    :ets.new(:connection, [:set, :protected, :named_table])
  end
end
