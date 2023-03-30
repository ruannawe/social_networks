defmodule SocialNetworks.Models.SocialUpdateTest do
  use ExUnit.Case, async: true

  alias SocialNetworks.Models.SocialUpdate

  describe "lookup/1" do
    setup do
      # Set up the ETS table with some sample data

      {:ok, true} = SocialUpdate.init()

      :ets.insert(
        :social_update,
        {"twitter", [%{content: "test content", username: "test user"}]}
      )

      :ets.insert(
        :social_update,
        {"facebook", [%{content: "test content", username: "test user"}]}
      )

      :ets.insert(
        :social_update,
        {"instagram", [%{content: "test content", username: "test user"}]}
      )

      :ok
    end

    test "returns the correct data for a valid social network" do
      assert SocialUpdate.lookup("twitter") == [%{content: "test content", username: "test user"}]
    end

    test "raises an error for an invalid social network" do
      result =
        try do
          SocialUpdate.lookup("invalid_network")
        rescue
          ArgumentError -> {:error, "Invalid social network"}
        end

      assert {:error, "Invalid social network"} == result
    end
  end

  describe "insert/2" do
    setup do
      # Set up the ETS table with some sample data
      SocialUpdate.init()
      :ets.insert(:social_update, {"twitter", []})
      :ok
    end

    test "insert updates for a valid social network" do
      SocialUpdate.insert("twitter", [%{content: "test content", username: "test user"}])
      assert SocialUpdate.lookup("twitter") == [%{content: "test content", username: "test user"}]
    end

    test "raises an error for an invalid social network" do
      result =
        try do
          SocialUpdate.insert("invalid_network", [
            %{content: "test content", username: "test user"}
          ])
        rescue
          ArgumentError -> {:error, "Invalid social network"}
        end

      assert {:error, "Invalid social network"} == result
    end
  end
end
