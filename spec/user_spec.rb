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
      calendars.length.should eql(9)
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
      calendar.id.should eql(NEW_CALENDAR_ID)
      calendar.title.should eql("foo")
    end
  end

end