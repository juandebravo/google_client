require 'google_client'
require 'spec_helper'
require 'webmock/rspec'

describe GoogleClient::Calendar do
  let(:user) do
    GoogleClient::User.new(USER_TOKEN)
  end

  let(:calendar) do
    GoogleClient::Calendar.new({:user => user, :id => CALENDAR_ID})
  end

  describe "while initializing" do
    
    it "should set the OAuth credentials properly" do
      user.oauth_credentials.should eql(USER_TOKEN)
    end

  end

  describe "while fetching events" do
    it "should fetch all the calendar events when no param is provided" do      
      pending("need to be developed")
    end
  end

  describe "while deleting a calendar" do
    it "should delete the calendar when a valid id is set" do
      pending("need to be developed")
    end
  end
end