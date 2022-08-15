defmodule Katty.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Katty.Repo,
      KattyWeb.Telemetry,
      {Phoenix.PubSub, name: Katty.PubSub},
      KattyWeb.Endpoint,
      {Oban, oban_config()},
    ]
    opts = [strategy: :one_for_one, name: Katty.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    KattyWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:katty, Oban)
  end
end
