require 'google_client'
require 'spec_helper'
require 'webmock/rspec'

describe GoogleClient::User do
  describe "while initializing" do
    it "should set the OAuth credentials properly" do
      GoogleClient::User.new(USER_TOKEN).oauth_credentials.should eql(USER_TOKEN)
    end
  end

  describe "while fetching calendars" do
    it "should fetch all the user calendars when no calendar_id is provided" do
      stub_request(:get, "https://www.google.com/calendar/feeds/default/allcalendars/full?alt=json").
            with(:headers => {"Accept" => "application/json", "Content-Type" => "application/json", :Authorization => "OAuth #{USER_TOKEN}"}).
            to_return(:status => 200, :body => GoogleResponseMocks.all_calendars, :headers => {})

      calendars = GoogleClient::User.new(USER_TOKEN).calendar
      calendars.should be_instance_of(Array)
      calendars.length.should eql(2)
      calendars.each do |calendar|
        calendar.should respond_to(:id)
        calendar.id.should_not be_empty
      end
    end

    it "should fetch a specific calendar when calendar_id is provided" do
      stub_request(:get, "https://www.google.com/calendar/feeds/default/owncalendars/full/#{CALENDAR_ID}?alt=json").
            with(:headers => {"Accept" => "application/json", "Content-Type" => "application/json", :Authorization => "OAuth #{USER_TOKEN}"}).
            to_return(:status => 200, :body => GoogleResponseMocks.one_calendar, :headers => {})
      calendar = GoogleClient::User.new(USER_TOKEN).calendar(CALENDAR_ID)
      calendar.should be_instance_of(GoogleClient::Calendar)
      calendar.should respond_to(:id)
      calendar.id.should_not be_empty
    end
  end

  describe "while creating calendars" do
    it "should create a calendar with valid title and details" do
      stub_request(:post, "https://www.google.com/calendar/feeds/default/owncalendars/full?").
            with(:body => "{\"data\":{\"title\":\"foo\",\"details\":\"bar\"}}",
            :headers => {"Accept" => "application/json", "Content-Type" => "application/json", :Authorization => "OAuth #{USER_TOKEN}"}).
            to_return(:status => 200, :body => GoogleResponseMocks.create_calendar, :headers => {})
      calendar = GoogleClient::User.new(USER_TOKEN).create_calendar({:title => "foo", :details => "bar"})
      calendar.should be_instance_of(GoogleClient::Calendar)
      calendar.id.should eql(NEW_CALENDAR_ID)
      calendar.title.should eql("foo")
    end
  end

  describe "while fetching contacts" do

    it "should fetch all the user contacts when no filter is provided" do
      stub_request(:get, "https://www.google.com/m8/feeds/contacts/default/full?alt=json&max-results=1000").
            with(:headers => {"Accept" => "application/json", "Content-Type" => "application/json", :Authorization => "OAuth #{USER_TOKEN}"}).
            to_return(:status => 200, :body => GoogleResponseMocks.all_contacts(100), :headers => {})
      
      contacts = GoogleClient::User.new(USER_TOKEN).contacts
      contacts.should be_instance_of(Array)
      contacts.length.should eql(100)
      contacts.each do |contact|
        contact.should be_instance_of(GoogleClient::Contact)
        contact.should have_valid_attributes CONTACT_NAME, [CONTACT_EMAIL], [CONTACT_PN]
      end
      
    end
  end

  describe "while refreshing auth token" do
    describe "when credentials are valid" do
      it "should return a valid access token" do
        refresh_token = "valid-refresh-token"
        stub_request(:post, "https://accounts.google.com/o/oauth2/token?").
            with(:body => "client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&refresh_token=#{refresh_token}&grant_type=refresh_token",
            :headers => {"Content-Type" => "application/x-www-form-urlencoded", :Authorization => "OAuth #{USER_TOKEN}"}).
            to_return(:status => 200, :body => GoogleResponseMocks.refresh_token, :headers => {})
        user = GoogleClient::User.new(USER_TOKEN)    
        token = user.refresh refresh_token, CLIENT_ID, CLIENT_SECRET
        token.should be_instance_of(Hash)
        ["access_token", "token_type", "expires_in"].each do |key|
          token.should have_key key
        end
        user.oauth_credentials.should eql USER_TOKEN
      end

      it "should return a valid access token and update the oauth credentials" do
        refresh_token = "valid-refresh-token"
        stub_request(:post, "https://accounts.google.com/o/oauth2/token?").
            with(:body => "client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&refresh_token=#{refresh_token}&grant_type=refresh_token",
            :headers => {"Content-Type" => "application/x-www-form-urlencoded", :Authorization => "OAuth #{USER_TOKEN}"}).
            to_return(:status => 200, :body => GoogleResponseMocks.refresh_token, :headers => {})
        user = GoogleClient::User.new(USER_TOKEN)    
        token = user.refresh! refresh_token, CLIENT_ID, CLIENT_SECRET
        token.should be_instance_of(Hash)
        ["access_token", "token_type", "expires_in"].each do |key|
          token.should have_key key
        end
        user.oauth_credentials.should eql "a-valid-new-access-token"
      end
    end
  end

end