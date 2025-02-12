defmodule ElixirBank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirBankWeb.Telemetry,
      ElixirBank.Repo,
      {DNSCluster, query: Application.get_env(:elixir_bank, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirBank.PubSub},
      # Start a worker by calling: ElixirBank.Worker.start_link(arg)
      # {ElixirBank.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirBankWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirBank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirBankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
