defmodule SocialNetworksWeb.Client.Http.SocialUpdatesClientTest do
  use ExUnit.Case
  import SocialNetworksWeb.Client.Http.SocialUpdatesClient

  test "get returns standardized social updates for Twitter" do
    expected = [%{username: "@GuyEndoreKaiser", content: "Nice twitter here!"}]

    BaseClient
    |> expect_receive(:get, fn _ ->
      {:ok, [%{"username" => "@GuyEndoreKaiser", "tweet" => "Nice twitter here!"}]}
    end)

    assert get(%{url: "https://twitter.com/api/updates", name: :twitter}) == {:ok, expected}
  end

  test "get returns standardized social updates for Facebook" do
    expected = [%{username: "Some Friend", content: "Here's some photos."}]

    BaseClient
    |> expect_receive(:get, fn _ ->
      {:ok, [%{"name" => "Some Friend", "status" => "Here's some photos."}]}
    end)

    assert get(%{url: "https://facebook.com/api/updates", name: :facebook}) == {:ok, expected}
  end

  test "get returns standardized social updates for Instagram" do
    expected = [%{username: "hipster1", content: "food"}]

    BaseClient
    |> expect_receive(:get, fn _ ->
      {:ok, [%{"username" => "hipster1", "picture" => "food"}]}
    end)

    assert get(%{url: "https://instagram.com/api/updates", name: :instagram}) == {:ok, expected}
  end
end
