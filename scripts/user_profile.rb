$:.unshift(File.join("../", "lib")).unshift(".")

require 'google_client'
require 'script_config'

user = GoogleClient::User.new AUTH_TOKEN

puts user.profile
