defmodule SocialNetworksWeb.Client.Http.BaseClient do
  use HTTPoison.Base

  def get(url) do
    try do
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, Poison.decode!(body)}

        {:error, %HTTPoison.Error{reason: _reason}} ->
          {:ok, []}
      end
    rescue
      _ -> {:ok, []}
    end
  end
end
