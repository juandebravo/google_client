$:.unshift(File.join("../", "lib")).unshift(".")

require 'google_client'
require 'script_config'

user = GoogleClient::User.new AUTH_TOKEN

calendar = user.calendar(CALENDAR_ID)

event = GoogleClient::Event.new({:id => ARGV.shift, :calendar => calendar})

puts event.delete