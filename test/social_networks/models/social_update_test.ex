defmodule SocialNetworks.Models.SocialUpdateTest do
  use ExUnit.Case

  describe "init/0" do
    test "initializes the social_update ETS table" do
      :ets.delete(:social_update)
      assert :ets.whereis(:social_update) == :undefined

      SocialNetworks.Models.SocialUpdate.init()

      assert :ets.whereis(:social_update) != :undefined
    end

    test "inserts empty updates for each social network" do
      :ets.delete(:social_update)
      SocialNetworks.Models.SocialUpdate.init()

      assert :ets.lookup(:social_update, "twitter") == [[]]
      assert :ets.lookup(:social_update, "facebook") == [[]]
      assert :ets.lookup(:social_update, "instagram") == [[]]
    end

    test "does not re-initialize the table if it already exists" do
      :ets.delete(:social_update)
      SocialNetworks.Models.SocialUpdate.init()

      table1 = :ets.whereis(:social_update)

      SocialNetworks.Models.SocialUpdate.init()

      table2 = :ets.whereis(:social_update)

      assert table1 == table2
    end
  end

  describe "lookup/1" do
    test "returns the updates for a valid social network" do
      :ets.delete(:social_update)
      SocialNetworks.Models.SocialUpdate.init()

      social_network = "twitter"
      updates = ["Update 1", "Update 2"]
      :ets.insert(:social_update, {social_network, updates})

      assert SocialNetworks.Models.SocialUpdate.lookup(social_network) == updates
    end

    test "raises an exception for an invalid social network" do
      assert_raise ArgumentError, "Invalid social network" do
        SocialNetworks.Models.SocialUpdate.lookup("invalid_network")
      end
    end
  end

  describe "save/2" do
    test "inserts updates for a valid social network" do
      :ets.delete(:social_update)
      SocialNetworks.Models.SocialUpdate.init()

      social_network = "twitter"
      updates = ["Update 1", "Update 2"]

      SocialNetworks.Models.SocialUpdate.save(social_network, updates)

      assert :ets.lookup(:social_update, social_network) == updates
    end

    test "raises an exception for an invalid social network" do
      assert_raise ArgumentError, "Invalid social network" do
        SocialNetworks.Models.SocialUpdate.save("invalid_network", [])
      end
    end
  end
end
