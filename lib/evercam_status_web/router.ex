defmodule ServerStatusWeb.Router do
  use ServerStatusWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ServerStatusWeb do
    pipe_through :browser # Use the default browser stack

    get "/", UserController, :index
    post "/", UserController, :create
    delete "/", UserController, :delete

    get "/console", ConsoleController, :index
    get "/raid", ConsoleController, :raid
  end

  # Other scopes may use custom stacks.
  scope "/api", ServerStatusWeb do
    pipe_through :api

    post "/create_raid", API.RaidController, :create_raid
    post "/details_about_raid", API.RaidController, :details_about_raid
    get "/load_raid_servers", API.RaidController, :load_raid_servers
  end
end
