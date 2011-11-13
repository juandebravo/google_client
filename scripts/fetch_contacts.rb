
$:.unshift(File.join("../", "lib")).unshift(".")

require 'google_client'
require 'script_config'
require 'pry'

user = GoogleClient::User.new AUTH_TOKEN

begin
  puts user.contacts
rescue GoogleClient::AuthenticationError => ex
  puts "Invalid token"
end

