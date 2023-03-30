defmodule SocialNetworksWeb.Jobs.SocialSyncTest do
  use ExUnit.Case, async: true
  use Mimic

  alias SocialNetworks.Models.SocialUpdate
  alias SocialNetworksWeb.Jobs.SocialSync
  alias SocialNetworksWeb.Client.Http.SocialUpdatesClient

  describe "set_updates/0" do
    setup do
      {:ok, true} = SocialUpdate.init()

      Mimic.copy(SocialUpdatesClient)

      :ok
    end

    test "Check if SocialSync child process is NOT running in background" do
      social_sync_pid = Process.whereis(SocialSync)

      assert social_sync_pid == nil
    end

    test "when the social updates from ALL social networks keys are empty" do
      assert SocialUpdate.lookup("twitter") == []
      assert SocialUpdate.lookup("facebook") == []
      assert SocialUpdate.lookup("instagram") == []
    end

    test "when the social updates from Twitter are filled inside ETS database" do
      # number of elements in function SocialNetworks.Models.SocialUpdate.available_social_networks()
      call_times = 3

      Mimic.expect(SocialUpdatesClient, :get, call_times, fn _ ->
        [%{username: "John", content: "Hello Twitter!"}]
      end)

      SocialSync.set_updates()

      assert SocialUpdate.lookup("twitter") == [%{username: "John", content: "Hello Twitter!"}]
    end

    test "when the social updates from Facebook are filled inside ETS database" do
      # number of elements in function SocialNetworks.Models.SocialUpdate.available_social_networks()
      call_times = 3

      Mimic.expect(SocialUpdatesClient, :get, call_times, fn _ ->
        [%{username: "John", content: "Hello Facebook!"}]
      end)

      SocialSync.set_updates()

      assert SocialUpdate.lookup("facebook") == [%{username: "John", content: "Hello Facebook!"}]
    end

    test "when the social updates from Instagram are filled inside ETS database" do
      # number of elements in function SocialNetworks.Models.SocialUpdate.available_social_networks()
      call_times = 3

      Mimic.expect(SocialUpdatesClient, :get, call_times, fn _ ->
        [%{username: "John", content: "Hello Twitter!"}]
      end)

      SocialSync.set_updates()

      assert SocialUpdate.lookup("twitter") == [
               %{username: "John", content: "Hello Twitter!"}
             ]
    end
  end
end
