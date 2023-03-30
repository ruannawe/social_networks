defmodule SocialNetworksWeb.Client.Http.BaseClientTest do
  use ExUnit.Case
  use Mimic

  describe "get/1" do
    test "returns the decoded Twitter response body when HTTPoison returns a 200 status code" do
      Mimic.copy(HTTPoison)

      # Mock the HTTP response
      Mimic.expect(HTTPoison, :get, fn _ ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: "[{\"tweet\": \"Hello World!\",\"username\": \"@GuyEndoreKaiser\"}]",
           headers: [],
           request_url: "https://takehome.io/twitter",
           request: %HTTPoison.Request{
             method: :get,
             url: "https://takehome.io/twitter",
             headers: [],
             body: "",
             params: %{},
             options: []
           }
         }}
      end)

      # Call the function being tested
      response = SocialNetworksWeb.Client.Http.BaseClient.get("https://takehome.io/twitter")

      # Assert that the response is the expected decoded body
      assert response == [
               %{
                 "username" => "@GuyEndoreKaiser",
                 "tweet" => "Hello World!"
               }
             ]
    end

    test "returns the decoded Facebook response body when HTTPoison returns a 200 status code" do
      Mimic.copy(HTTPoison)

      # Mock the HTTP response
      Mimic.expect(HTTPoison, :get, fn _ ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: "[{\"name\": \"Some Friend\", \"status\": \"Hello Facebook!\"}]",
           headers: [],
           request_url: "https://takehome.io/facebook",
           request: %HTTPoison.Request{
             method: :get,
             url: "https://takehome.io/facebook",
             headers: [],
             body: "",
             params: %{},
             options: []
           }
         }}
      end)

      # Call the function being tested
      response = SocialNetworksWeb.Client.Http.BaseClient.get("https://takehome.io/twitter")

      # Assert that the response is the expected decoded body
      assert response == [
               %{
                 "name" => "Some Friend",
                 "status" => "Hello Facebook!"
               }
             ]
    end

    test "returns the decoded Instagram response body when HTTPoison returns a 200 status code" do
      Mimic.copy(HTTPoison)

      # Mock the HTTP response
      Mimic.expect(HTTPoison, :get, fn _ ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: "[{\"picture\": \"food\", \"username\": \"hipster1\"}]",
           headers: [],
           request_url: "https://takehome.io/instagram",
           request: %HTTPoison.Request{
             method: :get,
             url: "https://takehome.io/instagram",
             headers: [],
             body: "",
             params: %{},
             options: []
           }
         }}
      end)

      # Call the function being tested
      response = SocialNetworksWeb.Client.Http.BaseClient.get("https://takehome.io/twitter")

      # Assert that the response is the expected decoded body
      assert response == [
               %{"picture" => "food", "username" => "hipster1"}
             ]
    end

    test "returns an empty list when HTTPoison returns an error" do
      Mimic.copy(HTTPoison)

      # Mock the HTTP response
      Mimic.expect(HTTPoison, :get, fn
        _ -> {:error, %HTTPoison.Error{reason: :timeout}}
      end)

      # Call the function being tested
      response = SocialNetworksWeb.Client.Http.BaseClient.get("https://takehome.io/twitter")

      # Assert that the response is an empty list
      assert response == []
    end
  end
end
