defmodule UsuarisWeb.Router do
  use UsuarisWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UsuarisWeb do
    pipe_through :api
  end
end
