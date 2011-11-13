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
      http_connection = double("HttpConnection")
      response = double("HttpResponse")
      response.stub(:code) { 200 }
      response.stub(:body) { "{\"version\":\"1.0\",\"encoding\":\"UTF-8\",\"feed\":\
        {\"xmlns\":\"http://www.w3.org/2005/Atom\",\"xmlns$openSearch\":\"http://a9.com/-/spec/opensearchrss/1.0/\",\
          \"xmlns$gCal\":\"http://schemas.google.com/gCal/2005\",\"xmlns$gd\":\"http://schemas.google.com/g/2005\",\
          \"id\":{\"$t\":\"http://www.google.com/calendar/feeds/md8goqfs0pkpfbq0rintm786e4%40group.calendar.google.com/private/full\"},\
          \"updated\":{\"$t\":\"2011-11-13T22:11:56.000Z\"},\"category\":[{\"scheme\":\"http://schemas.google.com/g/2005#kind\",\
          \"term\":\"http://schemas.google.com/g/2005#event\"}],\"title\":{\"$t\":\"connfurence\",\"type\":\"text\"},\
          \"subtitle\":{\"$t\":\"This calendar must be used by the user to create conference events.\",\"type\":\"text\"},\
          \"link\":[{\"rel\":\"alternate\",\"type\":\"text/html\",\
          \"href\":\"https://www.google.com/calendar/embed?src=md8goqfs0pkpfbq0rintm786e4@group.calendar.google.com\"},\
          {\"rel\":\"http://schemas.google.com/g/2005#feed\",\"type\":\"application/atom+xml\",\
            \"href\":\"https://www.google.com/calendar/feeds/md8goqfs0pkpfbq0rintm786e4%40group.calendar.google.com/private/full\"},\
            {\"rel\":\"http://schemas.google.com/g/2005#post\",\"type\":\"application/atom+xml\",\
              \"href\":\"https://www.google.com/calendar/feeds/md8goqfs0pkpfbq0rintm786e4%40group.calendar.google.com/private/full\"},\
              {\"rel\":\"http://schemas.google.com/g/2005#batch\",\"type\":\"application/atom+xml\",\
                \"href\":\"https://www.google.com/calendar/feeds/md8goqfs0pkpfbq0rintm786e4%40group.calendar.google.com/private/full/batch\"},\
                {\"rel\":\"self\",\"type\":\"application/atom+xml\",\
                  \"href\":\"https://www.google.com/calendar/feeds/md8goqfs0pkpfbq0rintm786e4%40group.calendar.google.com/private/\
                  full?alt=json&max-results=25&start-min=2011-11-14T00%3A12%3A29%2B02%3A00&start-max=2011-11-14T10%3A12%3A29%2B02%3A00\"}],\
                  \"author\":[{\"name\":{\"$t\":\"connfurence\"}}],\"generator\":{\"$t\":\"Google Calendar\",\"version\":\"1.0\",\
                  \"uri\":\"http://www.google.com/calendar\"},\"openSearch$totalResults\":{\"$t\":1},\"openSearch$startIndex\":\
                  {\"$t\":1},\"openSearch$itemsPerPage\":{\"$t\":25},\"gCal$timezone\":{\"value\":\"Asia/Jerusalem\"},\"gCal$timesCleaned\":\
                  {\"value\":0},\"gd$where\":{\"valueString\":\"Tel Aviv\"},\"entry\":[{\"id\":{\"$t\":\
                  \"http://www.google.com/calendar/feeds/md8goqfs0pkpfbq0rintm786e4%40group.calendar.google.com/private/full/001q3b6f0n268mea33o59dopvs\"}\
                  ,\"published\":{\"$t\":\"2011-11-13T22:11:55.000Z\"},\"updated\":{\"$t\":\"2011-11-13T22:11:55.000Z\"},\
                  \"category\":[{\"scheme\":\"http://schemas.google.com/g/2005#kind\",\"term\":\"http://schemas.google.com/g/2005#event\"}],\
                  \"title\":{\"$t\":\"This is a cool event\",\"type\":\"text\"},\"content\":{\"$t\":\"foo =\u003e bar\",\"type\":\"text\"},\
                  \"link\":[{\"rel\":\"alternate\",\"type\":\"text/html\",\"href\":\"https://www.google.com/calendar/event?eid=MDAxcTNiNmYwbjI2OG1lYTMzbzU5ZG9wdnMgbWQ4Z29xZnMwcGtwZmJxMHJpbnRtNzg2ZTRAZw\",\"title\":\"alternate\"},{\"rel\":\"self\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/md8goqfs0pkpfbq0rintm786e4%40group.calendar.google.com/private/full/001q3b6f0n268mea33o59dopvs\"},{\"rel\":\"edit\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/md8goqfs0pkpfbq0rintm786e4%40group.calendar.google.com/private/full/001q3b6f0n268mea33o59dopvs/63456905515\"}],\"author\":[{\"name\":{\"$t\":\"juandebravo@gmail.com\"},\"email\":{\"$t\":\"juandebravo@gmail.com\"}}],\"gd$comments\":{\"gd$feedLink\":{\"href\":\"https://www.google.com/calendar/feeds/md8goqfs0pkpfbq0rintm786e4%40group.calendar.google.com/private/full/001q3b6f0n268mea33o59dopvs/comments\"}},\"gd$eventStatus\":{\"value\":\"http://schemas.google.com/g/2005#event.confirmed\"},\"gd$where\":[{}],\"gd$who\":[{\"email\":\"md8goqfs0pkpfbq0rintm786e4@group.calendar.google.com\",\"rel\":\"http://schemas.google.com/g/2005#event.organizer\",\"valueString\":\"connfurence\"}],\"gd$when\":[{\"endTime\":\"2011-11-14T00:13:07.000+02:00\",\"startTime\":\"2011-11-14T00:12:07.000+02:00\"}],\"gd$transparency\":{\"value\":\"http://schemas.google.com/g/2005#event.opaque\"},\"gd$visibility\":{\"value\":\"http://schemas.google.com/g/2005#event.default\"},\"gCal$anyoneCanAddSelf\":{\"value\":\"false\"},\"gCal$guestsCanInviteOthers\":{\"value\":\"true\"},\"gCal$guestsCanModify\":{\"value\":\"false\"},\"gCal$guestsCanSeeGuests\":{\"value\":\"true\"},\"gCal$sequence\":{\"value\":0},\"gCal$uid\":{\"value\":\"001q3b6f0n268mea33o59dopvs@google.com\"}}]}}"}
      
      http_connection.stub(:get).with("/calendar/feeds/#{CALENDAR_ID}/private/full") {
        response        
      }
      calendar.stub(:connection) { http_connection }

      events = calendar.events
      events.length.should == 1
      event = events[0]
      event.should be_instance_of GoogleClient::Event
      event.id.should == "001q3b6f0n268mea33o59dopvs"
      event.title.should == "This is a cool event"
      event.description.should == "foo => bar"
      event.start_time.should == "2011-11-14T00:12:07.000+02:00"
      event.end_time.should == "2011-11-14T00:13:07.000+02:00"
    end
  end

  describe "while deleting a calendar" do
    it "should delete the calendar when a valid id is set" do
      http_connection = double("HttpConnection")
      response = double("HttpResponse")
      response.stub(:code) { 200 }
      http_connection.stub(:delete).with("/calendar/feeds/default/owncalendars/full/#{CALENDAR_ID}") {
        response        
      }
      calendar.stub(:connection) { http_connection }
      calendar.delete.should be_true
    end
  end
end