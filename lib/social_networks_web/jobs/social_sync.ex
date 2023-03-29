defmodule SocialNetworksWeb.Jobs.SocialSync do
  import SocialNetworksWeb.Client.Http.SocialUpdatesClient
  alias SocialNetworks.Models.SocialUpdate
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init([]) do
    SocialUpdate.init()

    schedule_job()

    {:ok, nil}
  end

  def handle_info(:job_timer, state) do
    set_updates()
    schedule_job()
    {:noreply, state}
  end

  defp schedule_job() do
    Process.send_after(self(), :job_timer, 1000)
  end

  defp set_updates() do
    Enum.each(social_networks(), fn social_network ->
      updates = get(social_network)

      if updates != [], do: save(updates, social_network[:name])
    end)
  end

  defp save(updates, name) do
    SocialUpdate.save(to_string(name), updates)
  end

  defp social_networks() do
    [
      %{url: Application.get_env(:social_networks, :twitter_url), name: :twitter},
      %{url: Application.get_env(:social_networks, :facebook_url), name: :facebook},
      %{url: Application.get_env(:social_networks, :instagram_url), name: :instagram}
    ]
  end
end
