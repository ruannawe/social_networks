defmodule SocialNetworksWeb.Jobs.SocialSyncTest do
  use ExUnit.Case, async: true
  use Mimic

  alias SocialNetworks.Models.SocialUpdate
  alias SocialNetworksWeb.Jobs.SocialSync

  describe "handle_info/2" do
    test "Check if SocialSync child process is running in background" do
      social_sync_pid = Process.whereis(SocialSync)

      assert social_sync_pid != nil
    end

    test "Check if the social updates from Twitter are filled inside ETS database" do
      Mimic.copy(SocialUpdate)

      Mimic.expect(SocialUpdate, :lookup, fn _ ->
        [{"twitter", [%{username: "John", content: "Hello Twitter!"}]}]
      end)

      response = SocialUpdate.lookup("twitter")

      assert response == [{"twitter", [%{username: "John", content: "Hello Twitter!"}]}]
    end

    test "Check if the social updates from Facebook are filled inside ETS database" do
      Mimic.copy(SocialUpdate)

      Mimic.expect(SocialUpdate, :lookup, fn _ ->
        [{"facebook", [%{username: "John", content: "Hello Facebook!"}]}]
      end)

      response = SocialUpdate.lookup("facebook")

      assert response == [{"facebook", [%{username: "John", content: "Hello Facebook!"}]}]
    end

    test "Check if the social updates from Instagram are filled inside ETS database" do
      Mimic.copy(SocialUpdate)

      Mimic.expect(SocialUpdate, :lookup, fn _ ->
        [{"instagram", [%{username: "John", content: "Hello Instagram!"}]}]
      end)

      response = SocialUpdate.lookup("instagram")

      assert response == [{"instagram", [%{username: "John", content: "Hello Instagram!"}]}]
    end
  end
end
