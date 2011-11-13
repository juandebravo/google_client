
$:.unshift(File.join("../", "lib")).unshift(".")

require 'google_client'
require 'script_config'
require 'pry'

user = GoogleClient::User.new AUTH_TOKEN

calendar = user.calendar(CALENDAR_ID)

puts calendar

