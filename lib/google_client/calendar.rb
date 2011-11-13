module GoogleClient
  class Calendar

    BASE_URL = "https://www.google.com/calendar/feeds"

    include Format

    attr_accessor :id
    attr_accessor :title
    attr_accessor :details
    attr_accessor :timezone
    attr_accessor :location

    def initialize(params)
      @user = params[:user]
      @user.nil? or @connection = @user.connection
      @id = params[:calendar_id] || params[:id]
      @title = params[:title]
      @details = params[:details]
      @timezone = params[:timezone]
      @location = params[:location]
      @json_mode = true
      block_given? and yield self
    end

    def to_s
      "#{self.class.name} => { id: #{@id}, title: #{@title}, :timezone => #{@timezone}, :location => #{@location} }"
    end

    def connection
      @connection or raise RuntimeError.new "Http connection not established"
    end

    ##
    # Save the Calendar in the server
    # 
    # @return Event instance
    def save
      if @id.nil?
        data = decode_response connection.post("/calendar/feeds/default/owncalendars/full", {:data => self.to_hash})
        self.id = data["data"]["id"].split("full/").last
      else
        data = decode_response connection.put("/calendar/feeds/default/owncalendars/full/#{@id}", {:apiVersion => "2.3", :data => self.to_hash})
      end
      self
    end

    def delete
      @id.nil? and raise Error.new "calendar cannot be deleted if has not an unique identifier"
      connection.delete("/calendar/feeds/default/owncalendars/full/#{@id}")
      true
    end

    def to_hash
      {
        :title => @title,
        :details => @details,
        :timeZone => @timezone,
        :location => @location
      }.delete_if{|k,v| v.nil?}
    end

    ##
    # Fetch a set of the events from the calendar
    # ==== Parameters
    # * *params*: Hash
    # ** *id*: optional, specific event identifier. If present, no other parameter will be considered
    # ** *from*: optional, if *to* is present and from is not, all events starting till *to* will be fetched
    # ** *to*: optional, if *from* is present and to is not, all events starting after *from* will be fetched
    #
    # ==== Return
    # * Nil if no event matches the query parameters.
    # * Event instance if only one Event matches the query parameter.
    # * An array of Event instances if more than one Event matches the query parameter.
    #
    def events(args = nil)
      events = if args.nil? || args.eql?(:all)
        events = decode_response connection.get "/calendar/feeds/#{id}/private/full"
        events = events["feed"]["entry"]
        events.map{ |event| Event.build_event(event, self)}
      elsif args.is_a?(String)
        Event.new({:id => args, :calendar => self}).fetch
      elsif args.is_a?(Hash)
        if args.is_a?(Hash) && args.has_key?(:id)
          Event.new({:id => args[:id], :calendar => self}).fetch
        else
          params = { "start-min" => args[:from],
                     "start-max" => args[:to]}
          events = decode_response connection.get "/calendar/feeds/#{id}/private/full", params
          events = events["feed"]["entry"]
          events = events.nil? ? [] : events.map{ |event| Event.build_event(event, self)}
        end
      else
        raise ArgumentError.new "Invalid argument type #{args.class}"
      end

    end

    ##
    # Fetch forthcoming events in the folowing *time* minutes
    def forthcoming_events(time = 3600)
      events({:from => Time.now.strftime("%Y-%m-%dT%k:%M:%S").concat(timezone).gsub(/ /,"0"),
              :to => (Time.now + time).strftime("%Y-%m-%dT%k:%M:%S").concat(timezone).gsub(/ /,"0")})
    end

    # Create a new event in the calendar
    # ==== Parameters
    # * *params* Hash options
    #   * c.send_event_notifications : true|false
    #   * c.title                    : event title (string)
    #   * c.description              : event detail description (string)
    #   * c.start_time               : start time (time format)
    #   * c.end_time                 : end time (time format)
    #   * c.attendees                : array of emails or hashes with :name and :email
    def create_event(params = {})
      event = if block_given?
                    Event.create(params.merge({:calendar => self}), &Proc.new)
                  else
                    Event.create(params.merge({:calendar => self}))
                  end
      event.save
    end

    def delete_event(event_id)
    end

    def fetch
      data = decode_response connection.get "/calendar/feeds/default/owncalendars/full/#{id}"
      self.class.build_calendar data["entry"], @user
    end

    # Helper to get the Timezone in rfc3339 format
    def timezone
      @@timezone ||= (
      timezone = Time.now.strftime("%z")
      timezone[0..2].concat(":").concat(timezone[3..-1])
      )
    end

    class << self
      def create(params)
        calendar = if block_given?
          new(params, &Proc.new)
        else
          new(params)
        end
      end

      def build_calendar(data, user = nil)

        id = begin
          data["id"]["$t"].split("full/").last
        rescue
          nil
        end

        details = begin
          data["summary"]["$t"]
        rescue
          ""
        end
        title = begin
          data["title"]["$t"]
        rescue
          ""
        end

        timezone = begin
          data["gCal$timezone"]["value"]
        rescue
          nil
        end

        location = begin
          data["gd$where"][0]["valueString"]
        rescue
          nil
        end
        
        Calendar.new({:id => id, 
                      :user => user, 
                      :title => title,
                      :details => details,
                      :location => location,
                      :timezone => timezone})
      end
    end
  end

end