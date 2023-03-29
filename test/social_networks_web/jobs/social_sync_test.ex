defmodule SocialNetworksWeb.Jobs.SocialSyncTest do
  use ExUnit.Case
  import SocialNetworksWeb.Jobs.SocialSync

  test "set_updates saves updates for all social networks" do
    # Mock the get function to return a list of updates for each social network
    SocialUpdatesClient
    |> expect_receive(:get, fn %{"url" => url, "name" => name} ->
      case name do
        :twitter ->
          {:ok, [%{"username" => "@GuyEndoreKaiser", "tweet" => "Nice twitter here!"}]}

        :facebook ->
          {:ok, [%{"name" => "Some Friend", "status" => "Here's some photos."}]}

        :instagram ->
          {:ok,
           [
             %{"username" => "hipster1", "picture" => "food"},
             %{"username" => "hipster2", "picture" => "coffee"},
             %{"username" => "hipster3", "picture" => "coffee"},
             %{"username" => "hipster4", "picture" => "food"},
             %{"username" => "hipster5", "picture" => "this one is of a cat"}
           ]}
      end
    end)

    # Call the set_updates function and assert that it saves the expected updates
    assert_receive {:ok, _} = SocialUpdate.init()
    assert_receive {:ok, _} = set_updates()
    assert_receive {:ok, _} = SocialUpdate.get("twitter")
    assert_receive {:ok, _} = SocialUpdate.get("facebook")
    assert_receive {:ok, _} = SocialUpdate.get("instagram")
  end
end
