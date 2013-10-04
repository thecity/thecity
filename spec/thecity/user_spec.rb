require 'helper'

describe TheCity::User do

  describe "#groups" do
    it "returns an array of TheCity::Group's when groups are set" do
      groups = [
        {
          :id => 5432154321,
          :name => "My Group",
        }
      ]
      user = TheCity::User.new(:id => 6753948, :groups => groups)
      expect(user.groups).to be_an Array
      expect(user.groups.first).to be_a TheCity::Group
      expect(user.groups.first.name).to eq("My Group")
    end

    it "is empty when not set" do
      user = TheCity::User.new(:id => 6753948)
      expect(user.groups).to be_empty
    end
  end

  describe "#gender" do
    it "returns the gender" do
      user = TheCity::User.new(:id => 6753948, :gender => "Female")
      expect(user.gender.to_s).to eq("Female")
    end
    it "returns nil when gender is not set" do
      user = TheCity::User.new(:id => 6753948)
      expect(user.gender).to be_nil
    end
  end

  describe "#gender?" do
    it "returns true when the gender is set" do
      user = TheCity::User.new(:id => 6753948, :gender => "Male")
      expect(user.gender?).to be_true
    end
    it "returns false when the url is not set" do
      user = TheCity::User.new(:id => 6753948)
      expect(user.gender?).to be_false
    end
  end

  #TODO: Make this work without VCR
  #describe "#permissions" do
  #  it "returns user permissions" do
  #    client = fire_up_test_client
  #    user = client.me
  #    expect(user.permissions).to be_an TheCity::Permissions
  #  end
  #end
end
