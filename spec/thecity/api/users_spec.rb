require 'helper'

describe TheCity::API::Users do

  before do
    @client = TheCity::API::Client.new(:app_id => "CK", :app_secret => "CS", :access_token => "AT")
  end

  describe "#me" do
    before do
      stub_get("/me").to_return(:body => fixture("me.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.me
      expect(a_get("/me")).to have_been_made
    end
    it "returns the requesting user" do
      user = @client.me
      expect(user).to be_a TheCity::User
      expect(user.id).to eq(6753948)
    end
  end

end
