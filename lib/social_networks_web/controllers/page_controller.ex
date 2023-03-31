defmodule SocialNetworksWeb.PageController do
  use SocialNetworksWeb, :controller
  alias SocialNetworks.Models.SocialUpdate

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def social_updates(conn, _params) do
    updates = [
      %{twitter: SocialUpdate.lookup("twitter")},
      %{facebook: SocialUpdate.lookup("facebook")},
      %{instagram: SocialUpdate.lookup("instagram")}
    ]

    json(conn, updates)
  end
end
