require 'google_client'

describe GoogleClient do
  describe "while initializing" do
    subject { GoogleClient.create_client("oauth_token") }

    it "should return a GoogleClient::User instance" do
      subject.should be_instance_of GoogleClient::User
    end
    
    its(:oauth_credentials) { should == "oauth_token" }
  end
end