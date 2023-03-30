defmodule SocialNetworks.Models.SocialUpdate do
  def init() do
    if :ets.whereis(:social_update) == :undefined do
      :ets.new(:social_update, [:set, :public, :named_table])

      available_social_networks()
      |> Enum.map(fn x ->
        :ets.insert(:social_update, {x, []})
      end)
    end

    {:ok, :ets.whereis(:social_update) != :undefined}
  end

  def lookup(social_network) do
    unless available_social_networks() |> Enum.member?(social_network) do
      raise ArgumentError, "Invalid social network"
    end

    :ets.lookup_element(:social_update, to_string(social_network), 2)
  end

  def insert(social_network, updates) do
    unless available_social_networks() |> Enum.member?(social_network) do
      raise ArgumentError, "Invalid social network"
    end

    :ets.insert(:social_update, {social_network, updates})
  end

  defp available_social_networks() do
    [
      "twitter",
      "facebook",
      "instagram"
    ]
  end
end
