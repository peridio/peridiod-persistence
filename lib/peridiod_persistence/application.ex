defmodule PeridiodPersistence.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias PeridiodPersistence.KV

  @impl true
  def start(_type, _args) do
    application_config = Application.get_all_env(:peridiod_persistence)

    children = [
      {KV, application_config}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PeridiodPersistence.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
