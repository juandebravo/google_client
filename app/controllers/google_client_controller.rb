
class GoogleClientController < ApplicationController

  # parameters required in both OAuth steps
  DEFAULT_PARAMS = {
    :client_id => Rails.application.config.google_client.client_id
  }
  
  # OAuth step1: redirect to Google endpoint with the application idenfitifer and the redirect uri
  def index
    _params = {
      :redirect_uri    => Rails.application.config.google_client.redirect_uri,
      :response_type   => "code",
      :scope           => Rails.application.config.google_client.scope,
      :access_type     => Rails.application.config.google_client.access_type.nil? ? "online" : Rails.application.config.google_client.access_type,
      #:approval_prompt => Rails.application.config.google_client.approval_prompt.nil? ? "force" : Rails.application.config.google_client.approval_prompt
    }
    _params.merge!(DEFAULT_PARAMS)
    
    redirect_to connection.create_uri("/o/oauth2/auth", _params).to_s
  end

  # OAuth step2: retrieve the code from Google, ask for a valid access token and
  # forward to the user defined uri
  def oauth2callback
    # This code is retrieved from Google

    _params = {
      :redirect_uri  => Rails.application.config.google_client.redirect_uri,
      :client_secret => Rails.application.config.google_client.client_secret,
      :grant_type    => "authorization_code",
      :code          => params[:code]
    }

    _params.merge!(DEFAULT_PARAMS)

    response = connection.post "/o/oauth2/token", _params
    
    if response.code.to_s.eql?("200")
      response = ActiveSupport::JSON.decode(response.body)

      if Rails.application.config.google_client.forward_action.nil? or !Rails.application.config.google_client.forward_action.is_a?(String)
        raise GoogleClient::Error.new("Invalid forward_action value")
      end

      url = Rails.application.config.google_client.forward_action.split("#")

      url.length == 2 or raise GoogleClient::Error.new("Invalid forward_action value")

      @data = response

      redirect_to ({
        :controller => url.first,
        :action => url.last,
        :access_token => response["access_token"],
        :token_type => response["token_type"],
        :expires_in => response["expires_in"],
        :refresh_token => response["refresh_token"]
      })

    else
      logger.error "Error #{response.code} while accessing to Google #{response.body}"
      raise RuntimeError, "Unable to access to Google"
    end
  end

  def show
    @data = {:access_token => params[:access_token], 
              :token_type => params[:token_type],
              :expires_in => params[:expires_in],
              :refresh_token => params[:refresh_token]}
  end

  
  private
  
  def connection
    @connection ||= GoogleClient::HttpConnection.new("https://accounts.google.com")
  end

end
