
USER_TOKEN = "this-should-be-a-valid-authentication-token"

CALENDAR_ID = "this-should-be-a-valid-calendar-id"

NEW_CALENDAR_ID = "this-should-be-a-valid-calendar-id"



CONTACT_NAME  = "foo bar"
CONTACT_ID    = "7fb4bd3asbd25633"
CONTACT_EMAIL = "foo@gmail.com"
CONTACT_PN    = "+44 7772 111111"

RSpec::Matchers.define :have_valid_attributes do |name, email, phone_number|
  match do |actual|

    actual.name.should eql(name)
    actual.email.class.should eql(email.class)
    actual.phone_number.class.should eql(phone_number.class)
    
    email = Array(email)
    actual_email = Array(actual.email)
    email.length.should eql(actual_email.length)
    email.each do |e|
      valid_email = actual_email.select{|ae| ae.eql?(e)}
      valid_email.length.should eql(1)
      valid_email[0].should eql(e)
    end

    phone_number = Array(phone_number)
    actual_phone_number = Array(actual.phone_number)
    phone_number.length.should eql(actual_phone_number.length)
    phone_number.each do |p|
      valid_phone_number = actual_phone_number.select{|ap| ap.eql?(p)}
      valid_phone_number.length.should eql(1)
      valid_phone_number[0].should eql(p)
    end

  end
end


module GoogleResponseMocks
  def self.all_calendars
    "{\"version\":\"1.0\",\"encoding\":\"UTF-8\",\
    \"feed\":{\
    \"xmlns\":\"http://www.w3.org/2005/Atom\",\
    \"xmlns$openSearch\":\"http://a9.com/-/spec/opensearchrss/1.0/\",\"xmlns$gCal\":\"http://schemas.google.com/gCal/2005\",\"xmlns$gd\":\"http://schemas.google.com/g/2005\",\
    \"id\":{\
      \"$t\":\"http://www.google.com/calendar/feeds/default/allcalendars/full\"},\
      \"updated\":{\"$t\":\"2011-10-31T13:51:29.764Z\"},\
      \"category\":[{\"scheme\":\"http://schemas.google.com/g/2005#kind\",\"term\":\"http://schemas.google.com/gCal/2005#calendarmeta\"}],\
      \"title\":{\
        \"$t\":\"foo_bar@gmail.com\'s Calendar List\",\"type\":\"text\"},\
        \"link\":[{\"rel\":\"alternate\",\"type\":\"text/html\",\"href\":\"https://www.google.com/calendar/render\"},{\"rel\":\"http://schemas.google.com/g/2005#feed\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/default/allcalendars/full\"},{\"rel\":\"http://schemas.google.com/g/2005#post\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/default/allcalendars/full\"},{\"rel\":\"self\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/default/allcalendars/full?alt=json\"}],\
        \"author\":[{\"name\":{\"$t\":\"foo_bar@gmail.com\"},\"email\":{\"$t\":\"foo_bar@gmail.com\"}}],\
        \"generator\":{\"$t\":\"Google Calendar\",\"version\":\"1.0\",\"uri\":\"http://www.google.com/calendar\"},\
        \"openSearch$startIndex\":{\"$t\":1},\
        \"entry\":[\
          {\"id\":{\"$t\":\"http://www.google.com/calendar/feeds/default/allcalendars/full/foo_bar%40gmail.com\"},\"published\":{\"$t\":\"2011-10-31T13:51:29.482Z\"},\"updated\":{\"$t\":\"2011-10-20T08:54:48.000Z\"},\"category\":[{\"scheme\":\"http://schemas.google.com/g/2005#kind\",\"term\":\"http://schemas.google.com/gCal/2005#calendarmeta\"}],\"title\":{\"$t\":\"Foo Bar\",\"type\":\"text\"},\"content\":{\"type\":\"application/atom+xml\",\"src\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/private/full\"},\"link\":[{\"rel\":\"alternate\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/private/full\"},{\"rel\":\"http://schemas.google.com/gCal/2005#eventFeed\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/private/full\"},{\"rel\":\"http://schemas.google.com/acl/2007#accessControlList\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/acl/full\"},{\"rel\":\"self\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/default/allcalendars/full/foo_bar%40gmail.com\"},{\"rel\":\"edit\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/default/allcalendars/full/foo_bar%40gmail.com\"}],\"author\":[{\"name\":{\"$t\":\"foo_bar@gmail.com\"},\"email\":{\"$t\":\"foo_bar@gmail.com\"}}],\"gCal$accesslevel\":{\"value\":\"owner\"},\"gCal$color\":{\"value\":\"#2952A3\"},\"gCal$hidden\":{\"value\":\"false\"},\"gCal$selected\":{\"value\":\"true\"},\"gCal$timezone\":{\"value\":\"Asia/Jerusalem\"},\"gCal$timesCleaned\":{\"value\":0}},\
          {\"id\":{\"$t\":\"http://www.google.com/calendar/feeds/default/allcalendars/full/foo_bar%40gmail.com\"},\"published\":{\"$t\":\"2011-10-31T13:51:29.482Z\"},\"updated\":{\"$t\":\"2011-10-20T08:54:48.000Z\"},\"category\":[{\"scheme\":\"http://schemas.google.com/g/2005#kind\",\"term\":\"http://schemas.google.com/gCal/2005#calendarmeta\"}],\"title\":{\"$t\":\"Foo Bar\",\"type\":\"text\"},\"content\":{\"type\":\"application/atom+xml\",\"src\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/private/full\"},\"link\":[{\"rel\":\"alternate\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/private/full\"},{\"rel\":\"http://schemas.google.com/gCal/2005#eventFeed\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/private/full\"},{\"rel\":\"http://schemas.google.com/acl/2007#accessControlList\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/acl/full\"},{\"rel\":\"self\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/default/allcalendars/full/foo_bar%40gmail.com\"},{\"rel\":\"edit\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/default/allcalendars/full/foo_bar%40gmail.com\"}],\"author\":[{\"name\":{\"$t\":\"foo_bar@gmail.com\"},\"email\":{\"$t\":\"foo_bar@gmail.com\"}}],\"gCal$accesslevel\":{\"value\":\"owner\"},\"gCal$color\":{\"value\":\"#2952A3\"},\"gCal$hidden\":{\"value\":\"false\"},\"gCal$selected\":{\"value\":\"true\"},\"gCal$timezone\":{\"value\":\"Asia/Jerusalem\"},\"gCal$timesCleaned\":{\"value\":0}}\
          ]}}"
  end

  def self.one_calendar
    "{\"version\":\"1.0\",\"encoding\":\"UTF-8\",\"entry\":{\
      \"xmlns\":\"http://www.w3.org/2005/Atom\",\
      \"xmlns$gCal\":\"http://schemas.google.com/gCal/2005\",\
      \"id\":{\
        \"$t\":\"http://www.google.com/calendar/feeds/default/owncalendars/full/foo_bar%40gmail.com\"},\
        \"published\":{\"$t\":\"2011-10-31T13:51:30.555Z\"},\"updated\":{\"$t\":\"2011-10-20T08:54:48.000Z\"},\
        \"category\":[{\"scheme\":\"http://schemas.google.com/g/2005#kind\",\"term\":\"http://schemas.google.com/gCal/2005#calendarmeta\"}],\
        \"title\":{\"$t\":\"Foo Bar\",\"type\":\"text\"},\
        \"content\":{\"type\":\"application/atom+xml\",\"src\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/private/full\"},\
        \"link\":[{\"rel\":\"alternate\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/private/full\"},{\"rel\":\"http://schemas.google.com/gCal/2005#eventFeed\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/private/full\"},{\"rel\":\"http://schemas.google.com/acl/2007#accessControlList\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/foo_bar%40gmail.com/acl/full\"},{\"rel\":\"self\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/default/owncalendars/full/foo_bar%40gmail.com\"},{\"rel\":\"edit\",\"type\":\"application/atom+xml\",\"href\":\"https://www.google.com/calendar/feeds/default/owncalendars/full/foo_bar%40gmail.com\"}],\
        \"author\":[{\"name\":{\"$t\":\"foo_bar@gmail.com\"},\"email\":{\"$t\":\"foo_bar@gmail.com\"}}],\
        \"gCal$accesslevel\":{\"value\":\"owner\"},\
        \"gCal$color\":{\"value\":\"#2952A3\"},\
        \"gCal$hidden\":{\"value\":\"false\"},\
        \"gCal$selected\":{\"value\":\"true\"},\
        \"gCal$timezone\":{\"value\":\"Asia/Jerusalem\"},\
        \"gCal$timesCleaned\":{\"value\":0}}}"
  end

  def self.create_calendar
    '{"apiVersion":"1.0","data":{"kind":"calendar#calendar","id":"http://www.google.com/calendar/feeds/default/owncalendars/full/'+NEW_CALENDAR_ID+'","created":"2011-10-31T14:33:52.882Z","updated":"1970-01-01T00:00:00.000Z","selfLink":"https://www.google.com/calendar/feeds/default/owncalendars/full/jq9dkvf8rrqkre9lf4k721vgs4%40group.calendar.google.com","canEdit":true}}'
  end

  def self.one_contact
    "{\"id\":\{\"$t\":\"http://www.google.com/m8/feeds/contacts/user%40gmail.com/base/7fb4bd3c0bd256bd\"},\
      \"updated\":{\"$t\":\"2011-09-20T06:55:55.544Z\"},\
      \"category\":[{\"scheme\":\"http://schemas.google.com/g/2005#kind\",\"term\":\"http://schemas.google.com/contact/2008#contact\"}],\
      \"title\":{\"type\":\"text\",\"$t\":\"#{CONTACT_NAME}\"},\
      \"link\":[{\"rel\":\"http://schemas.google.com/contacts/2008/rel#edit-photo\",\"type\":\"image/*\",\
        \"href\":\"https://www.google.com/m8/feeds/photos/media/user%40gmail.com/7fb4bd3c0bd256bd/1B2M2Y8AsgTpgAmY7PhCfg\"},\
        {\"rel\":\"self\",\"type\":\"application/atom+xml\",\
        \"href\":\"https://www.google.com/m8/feeds/contacts/user%40gmail.com/full/#{CONTACT_ID}\"},\
        {\"rel\":\"edit\",\"type\":\"application/atom+xml\",\
        \"href\":\"https://www.google.com/m8/feeds/contacts/user%40gmail.com/full/#{CONTACT_ID}/1316501755544001\"}],\
      \"gd$email\":[{\"rel\":\"http://schemas.google.com/g/2005#mobile\",\"address\":\"#{CONTACT_EMAIL}\"}],\
      \"gd$phoneNumber\":[{\"rel\":\"http://schemas.google.com/g/2005#mobile\",\"$t\":\"#{CONTACT_PN}\"}],\
      \"gd$extendedProperty\":[{\"xmlns\":\"\",\"name\":\"GCon\",\"$t\":\"\u003ccc\u003e0\u003c/cc\u003e\"}]}"
  end

  def self.all_contacts(contacts=10)
    "{\"feed\":{\"entry\":[#{Array.new(contacts,one_contact).join(',')}]}}"    
  end
end