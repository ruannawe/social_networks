defmodule SocialNetworksWeb.Client.Http.BaseClient do
  use HTTPoison.Base

  def get(url) do
    try do
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          Poison.decode!(body)

        {:error, %HTTPoison.Error{reason: _reason}} ->
          []
      end
    rescue
      _ -> []
    end
  end
end
