defmodule ServerStatus.Repo.Migrations.CreateRaids do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :name, :string
      add :ip, :string
      add :username, :string
      add :password, :string
      add :raid_type, :string
      add :raid_man, :string
      add :extra, :map

      timestamps()
    end

  end
end
