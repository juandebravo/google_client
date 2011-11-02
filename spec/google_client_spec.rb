require 'google_client'

describe GoogleClient do
  describe "while initializing" do
    it "should set the OAuth credentials properly" do
      GoogleClient.create_client("oauth_token").oauth_credentials.should eql("oauth_token")
    end
  end
end