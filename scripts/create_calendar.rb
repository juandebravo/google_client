$:.unshift(File.join("../", "lib")).unshift(".")

require 'google_client'
require 'script_config'

timezone = "Spain"
location = "Barcelona"

user = GoogleClient::User.new AUTH_TOKEN

calendar = user.create_calendar do |c|
  c.title    = "google_client"
  c.details  = "Calendar created using google_client gem."
  c.timezone = timezone
  c.location = location
end

puts calendar
