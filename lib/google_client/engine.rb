require 'rails'
require 'ostruct'

module GoogleClient
  #
  # This class defines the GoogleClient Rails Engine to handle OAuth authentication.
  # The Engine defines two new routes to handle each of the OAuth steps
  # 1.- forward the user request to Google server
  # 2.- get the oauth code, request a valid access token and forward the token info to a user defined action
  #
  # How to configure GoogleClient Engine
  #
  # :uri => Google API endpoint 
  # :client_id => token that identifies your application in OAuth mechanism
  # :client_secret => token that secures your communication in OAuth mechanism
  # :forward_action => controller#action where google_client#code action will redirect the user token data:
  #           - :access_token
  #           - :expires_in
  #           - :refresh_token
  #
  # These configuration can be included in an application initializer, i.e. config/initializers/google_client.rb
  #
  #      Rails.application.config.google_client.client_id = "<client_id>"
  #      Rails.application.config.google_client.client_secret = "<client_secret"
  #      Rails.application.config.google_client.forward_action = "controller#action" that will receive the user token data
  #
  
  class Engine < Rails::Engine
    
    # we need to create the hashblue config hash before loading the application initializer
    initializer :google_client, {:before => :load_config_initializers} do |app|

      app.config.google_client = OpenStruct.new
      # HashBlue API endpoint
      app.config.google_client.uri = "https://www.google.com"
    end
    
  end
end
