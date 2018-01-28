defmodule ServerStatus.Repo.Migrations.CreateRaids do
  use Ecto.Migration

  def change do
    create table(:raids) do
      add :name, :string
      add :ip, :string
      add :username, :string
      add :password, :string
      add :raid_type, :string

      timestamps()
    end

  end
end
