module GoogleClient
  class User

    attr_accessor :oauth_credentials
    attr_accessor :json_mode

    include Format

    def initialize(oauth_credentials, user_credentials = nil)
      @oauth_credentials = oauth_credentials
      @json_mode = true
    end

    # Get user profile
    #
    # ==== Return
    # * Profile instance
    def profile
      data = decode_response http.get "/m8/feeds/contacts/default/full", {"max-results" => 1}
      email = data["feed"]["id"]["$t"]
      Profile.new({:email => email, :external_id => email.split("@").first})
    rescue
      Profile.new
    end

    # Refresh an invalid access_token
    # ==== Parameters
    # * *refresh_token*
    # * *client_id*
    # * *client_secret*
    #
    # ==== Return
    # * Hash with the following keys:
    #   * access_token
    #   * token_type
    #   * expires_in
    # * BadRequestError if invalid refresh token or invalid client
    def refresh refresh_token, client_id, client_secret
      _params = {
        :client_id => client_id,
        :client_secret => client_secret,
        :refresh_token => refresh_token,
        :grant_type => "refresh_token"
      }
      data = HttpConnection.new("https://accounts.google.com",
                                    {:alt => "json"},
                                    {:Authorization => "OAuth #{oauth_credentials}",
                                     "Content-Type" => "application/x-www-form-urlencoded",
                                     :Accept => "application/json"}).post "/o/oauth2/token", _params
      decode_response data.body
    end

    # Same as refresh method, but also updates the oauth_credentials variable with the new granted token
    def refresh! refresh_token, client_id, client_secret
      data = refresh refresh_token, client_id, client_secret
      @oauth_credentials = data["access_token"]
      data
    end

    ##
    #
    # ==== Parameters
    # * *calendar_id* Calendar unique identifier
    #
    # ==== Return
    # * *Calendar* instance
    # * *Array of Calendar* instances
    def calendar(calendar_id = :all)
      calendars = if calendar_id.nil? || calendar_id.eql?(:all)
        calendars = decode_response http.get "/calendar/feeds/default/allcalendars/full"
        calendars = calendars["feed"]["entry"]
        calendars.map{ |calendar| Calendar.build_calendar(calendar, self)}
      elsif calendar_id.eql?(:own)
        calendars = decode_response http.get "/calendar/feeds/default/owncalendars/full"
        calendars = calendars["feed"]["entry"]
        calendars.map{ |calendar| Calendar.build_calendar(calendar, self)}
      elsif calendar_id.is_a?(String)
        Calendar.new({:id => calendar_id, :user => self}).fetch
      elsif calendar_id.is_a?(Hash)
        # TODO add support to {:title => calendar_title}
        raise ArgumentError.new "Invalid argument type #{calendar_id.class}"
      else
        raise ArgumentError.new "Invalid argument type #{calendar_id.class}"
      end
    end

    # Create a calendar
    #
    # ==== Parameters
    # * *params* Hash
    #   * :title
    #   * :details
    #   * :timezone
    #   * :location
    #
    # ==== Return
    # Calendar instance
    def create_calendar(params = {})
      calendar = if block_given?
                    Calendar.create(params.merge({:user => self}), &Proc.new)
                  else
                    Calendar.create(params.merge({:user => self}))
                  end
      calendar.save
    end

    # Fetch user contacts
    def contacts
      contacts = decode_response http.get "/m8/feeds/contacts/default/full", {"max-results" => "1000"}
      contacts = contacts["feed"]["entry"] || []
      contacts.map{|contact| Contact.build_contact(contact, self)}
    end

    ##
    # Method that creates and returns the HttpConnection instance that shall be used
    #
    # ==== Return
    # * *HttpConnection* instance
    def http
      @http ||= HttpConnection.new("https://www.google.com",
                                    {:alt => "json"},
                                    {:Authorization => "OAuth #{oauth_credentials}",
                                     "Content-Type" => "json",
                                     :Accept => "application/json"})
    end

    alias :connection :http

  end
end
