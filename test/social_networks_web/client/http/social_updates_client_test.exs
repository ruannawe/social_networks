defmodule SocialNetworksWeb.Client.Http.SocialUpdatesClientTest do
  use ExUnit.Case
  alias SocialNetworksWeb.Client.Http.SocialUpdatesClient

  test "get updates from Twitter" do
    Mimic.copy(SocialNetworksWeb.Client.Http.BaseClient)

    Mimic.expect(SocialNetworksWeb.Client.Http.BaseClient, :get, fn _url ->
      [
        %{
          "tweet" =>
            "If you live to be 100, you should make up some fake reason why, just to mess with people... like claim you ate a pinecone every single day.",
          "username" => "@GuyEndoreKaiser"
        }
      ]
    end)

    updates =
      SocialUpdatesClient.get(%{
        url: "https://twitter.com/api/1.1/statuses/user_timeline.json",
        name: :twitter
      })

    assert updates == [
             %{
               username: "@GuyEndoreKaiser",
               content:
                 "If you live to be 100, you should make up some fake reason why, just to mess with people... like claim you ate a pinecone every single day."
             }
           ]
  end

  test "get updates from Instagram" do
    Mimic.copy(SocialNetworksWeb.Client.Http.BaseClient)

    Mimic.expect(SocialNetworksWeb.Client.Http.BaseClient, :get, fn _url ->
      [
        %{"picture" => "food", "username" => "hipster1"}
      ]
    end)

    updates =
      SocialUpdatesClient.get(%{
        url: "https://instagram.com/api/user_posts.json",
        name: :instagram
      })

    assert updates == [
             %{username: "hipster1", content: "food"}
           ]
  end

  test "get updates from Facebook" do
    Mimic.copy(SocialNetworksWeb.Client.Http.BaseClient)

    Mimic.expect(SocialNetworksWeb.Client.Http.BaseClient, :get, fn _url ->
      [
        %{
          "name" => "Some Friend",
          "status" =>
            "Here's some photos of my holiday. Look how much more fun I'm having than you are!"
        }
      ]
    end)

    updates =
      SocialUpdatesClient.get(%{url: "https://facebook.com/api/user_posts.json", name: :facebook})

    assert updates == [
             %{
               username: "Some Friend",
               content:
                 "Here's some photos of my holiday. Look how much more fun I'm having than you are!"
             }
           ]
  end
end
