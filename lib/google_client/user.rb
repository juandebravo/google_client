module GoogleClient
  class User

    attr_accessor :oauth_credentials
    attr_accessor :json_mode

    include Format

    class Profile
      attr_accessor :email
      attr_accessor :external_id

      def initialize(params ={})
        @email = params[:email]
        @external_id = params[:external_id]
      end

      def to_s
        "#{self.class.name} => { email: #{@email}, external_id: #{@external_id} }"
      end
    end
    
    def initialize(oauth_credentials, user_credentials = nil)
      @oauth_credentials = oauth_credentials
      @json_mode = true
    end

    def profile
      data = decode_response http.get "/m8/feeds/contacts/default/full", {"max-results" => 1}
      email = data["feed"]["id"]["$t"]
      Profile.new({:email => email, :external_id => email.split("@").first})
    rescue
      Profile.new
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

    def contacts
      contacts = decode_response http.get "/m8/feeds/contacts/default/full", {"max-results" => "1000"}
      contacts = contacts["feed"]["entry"]
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