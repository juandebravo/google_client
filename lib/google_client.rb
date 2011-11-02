require 'json'
require "google_client/version"

module GoogleClient
  
  autoload :AuthenticationError, 'google_client/error'
  autoload :Calendar           , 'google_client/calendar'
  autoload :Error              , 'google_client/error'
  autoload :Event              , 'google_client/event'
  autoload :Format             , 'google_client/format'
  autoload :HttpConnection     , 'google_client/http_connection'
  autoload :NotFound           , 'google_client/error'
  autoload :User               , 'google_client/user'

  class << self
    def create_client(oauth_credentials)
      User.new(oauth_credentials)
    end
  end

end
