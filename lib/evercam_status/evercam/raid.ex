defmodule ServerStatus.Evercam.Raid do
  use Ecto.Schema
  import Ecto.Changeset
  alias ServerStatus.Evercam.Raid

  @ip_regex ~r/^(http(s?):\/\/)?(((www\.)?+[a-zA-Z0-9\.\-\_]+(\.[a-zA-Z]{2,3})+)|(\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b))(\/[a-zA-Z0-9\_\-\s\.\/\?\%\#\&\=]*)?$/

  schema "raids" do
    field :ip, :string
    field :name, :string
    field :password, :string
    field :raid_type, :string
    field :username, :string
    field :raid_man, :string

    timestamps()
  end

  @doc false
  def changeset(%Raid{} = raid, attrs) do
    raid
    |> cast(attrs, [:name, :ip, :username, :password, :raid_type, :raid_man])
    |> validate_required(:name, [message: "Name cannot be empty."])
    |> validate_required(:ip, [message: "IP / URL cannot be empty."])
    |> validate_required(:username, [message: "Username cannot be empty."])
    |> validate_required(:password, [message: "Password cannot be empty."])
    |> validate_length(:name, [min: 3, message: "Name should be at least 2 character(s)."])
    |> validate_length(:username, [min: 3, message: "Username should be at least 2 character(s)."])
    |> validate_length(:password, [min: 3, message: "Password should be at least 2 character(s)."])
    |> validate_format(:ip, @ip_regex, [message: "URL / IP format isn't valid!"])
  end
end
