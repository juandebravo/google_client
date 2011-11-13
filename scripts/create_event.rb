$:.unshift(File.join("../", "lib")).unshift(".")

require 'google_client'
require 'script_config'


user = GoogleClient::User.new AUTH_TOKEN

calendar = user.calendar(CALENDAR_ID)

start_time = Time.now.strftime("%Y-%m-%dT%H:%M:%S.000%z")
start_time = "#{start_time[0..-3]}:#{start_time[-2..-1]}"
end_time   = (Time.now+60).strftime("%Y-%m-%dT%H:%M:%S.000%z")
end_time   = "#{end_time[0..-3]}:#{end_time[-2..-1]}"

event = calendar.create_event do |e|
  e.send_event_notifications = true
  e.title       = "This is a cool event"
  e.description = "foo => bar"
  e.start_time  = start_time
  e.end_time    = end_time
end

puts event