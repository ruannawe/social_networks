defmodule SocialNetworksWeb.Jobs.SocialSyncTest do
  use ExUnit.Case

  import SocialNetworksWeb.Jobs.SocialSync

  test "set_updates saves expected updates" do
    expected_updates = [
      %{content: "food", username: "hipster1"},
      %{content: "coffee", username: "hipster2"},
      %{content: "this one is of a cat", username: "hipster5"}
    ]

    SocialUpdatesClientMock.get(:twitter) |> Mock.expect(:get, {:ok, expected_updates})

    SocialSync.set_updates()
    saved_updates = SocialUpdate.get(:twitter)

    assert saved_updates == expected_updates
  end

  defmodule SocialUpdatesClientMock do
    def get(:twitter) do
      Mock.stub(:get, fn _params ->
        {:ok,
         [
           %{username: "hipster1", tweet: "food"},
           %{username: "hipster2", tweet: "coffee"},
           %{username: "hipster5", tweet: "this one is of a cat"}
         ]}
      end)
    end

    def get(:facebook), do: Mock.stub(:get, fn _params -> {:ok, []} end)
    def get(:instagram), do: Mock.stub(:get, fn _params -> {:ok, []} end)
  end
end
