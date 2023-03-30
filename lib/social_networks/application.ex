defmodule SocialNetworks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SocialNetworksWeb.Telemetry,
      # Start the Ecto repository
      SocialNetworks.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SocialNetworks.PubSub},
      # Start Finch
      {Finch, name: SocialNetworks.Finch},
      # Start the Endpoint (http/https)
      SocialNetworksWeb.Endpoint,

      # Start a worker by calling: SocialNetworks.Worker.start_link(arg)
      # {SocialNetworks.Worker, arg}
    ]

    # Append custom child worker to children list
    children = append_social_sync_worker(children)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SocialNetworks.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SocialNetworksWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp append_social_sync_worker(children) do
    if Mix.env() != :test do
      children ++ [{SocialNetworksWeb.Jobs.SocialSync, []}]
    else
      children
    end
  end
end
