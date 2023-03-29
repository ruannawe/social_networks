defmodule SocialNetworksWeb.Client.Http.SocialUpdatesClient do
  alias SocialNetworksWeb.Client.Http.BaseClient

  def get(params) do
    {:ok, body} = BaseClient.get(params[:url])

    standardize_api_response(body, params[:name])
  end

  defp standardize_api_response(body, name) do
    updates = force_response_to_list(body)
    Enum.map(updates, fn update -> map_keys(update, name) end)
  end

  defp map_keys(update, name) do
    case name do
      n when n == :twitter ->
        %{username: update["username"], content: update["tweet"]}

      n when n == :facebook ->
        %{username: update["name"], content: update["status"]}

      n when n == :instagram ->
        %{username: update["username"], content: update["picture"]}

      _ ->
        raise ArgumentError, message: "invalid social network name"
    end
  end

  def force_response_to_list(body) do
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
