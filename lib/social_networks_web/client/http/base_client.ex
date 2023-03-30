defmodule SocialNetworksWeb.Client.Http.BaseClient do
  use HTTPoison.Base

  def get(url) do
    try do
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          force_response_to_list(Poison.decode!(body))

        {:error, %HTTPoison.Error{reason: _reason}} ->
          []

        _ ->
          []
      end
    rescue
      _ ->
        []
    end
  end

  defp force_response_to_list(body) do
    case(body) do
      x when is_map(x) ->
        [body]

      x when is_list(x) ->
        body

      _ ->
        []
    end
  end
end
