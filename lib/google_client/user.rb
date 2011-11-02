module GoogleClient
  class User

    attr_accessor :oauth_credentials
    attr_accessor :json_mode

    include Format
    
    def initialize(oauth_credentials, user_credentials = nil)
      @oauth_credentials = oauth_credentials
      @json_mode = true
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

    def create_calendar(params)
      calendar = if block_given?
                    Calendar.create(params.merge({:user => self}), &Proc.new)
                  else
                    Calendar.create(params.merge({:user => self}))
                  end
      calendar.save

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