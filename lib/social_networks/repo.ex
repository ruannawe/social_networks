defmodule SocialNetworks.Repo do
  use Ecto.Repo,
    otp_app: :social_networks,
    adapter: Ecto.Adapters.Postgres
end
