module GoogleClient
  class Event

    include Format

    attr_reader :id
    attr_accessor :calendar_id
    attr_accessor :calendar
    attr_accessor :title
    attr_accessor :description
    attr_accessor :attendees
    attr_accessor :start_time
    attr_accessor :end_time
    attr_accessor :location
    attr_accessor :attendees
    attr_accessor :send_event_notifications
    attr_accessor :comments

    def initialize(params = {})
      @id = params[:event_id] || params[:id] || nil
      @title = params[:title]
      @description = params[:description]
      @location = params[:location]
      @start_time = params[:start_time]
      @end_time = params[:end_time]
      @calendar_id = params[:calendar_id]
      @calendar = params[:calendar]
      @comments = params[:comments]
      @attendees = params[:attendees].nil? ? [] : params[:attendees].map{|x| x.kind_of?(String) ? {:email => x} : x}
      @send_event_notifications = params[:send_event_notifications]

      @calendar.nil? or @connection = @calendar.connection
      @json_mode = true
      block_given? and yield self
    end

    def to_s
      "#{self.class.name} => { id: #{@id}, title: #{@title}, description: #{@description}, :start_time => #{@start_time}, :end_time => #{@end_time}, :location => #{@location}, :attendees => #{@attendees}, :send_event_notifications => #{@send_event_notifications}, :calendar => #{@calendar} }"
    end

    def to_hash
      {
        :title => @title,
        :details => @description,
        :timeZone => @timezone,
        :when => [{:start => @start_time,
          :end => @end_time}],
        :attendees => @attendees.map{|x| {:valueString => x[:name], :email => x[:email]}},
        :sendEventNotifications  => @send_event_notifications || false
      }.delete_if{|k,v| v.nil?}
    end


    def connection
      @connection or raise RuntimeError.new "Http connection not established"
    end

    ##
    # Save the Event in the server
    # ==== Return
    # * *Event* instance
    def save
      if @id.nil?
        data = decode_response connection.post("/calendar/feeds/#{calendar}/private/full", {:data => self.to_hash})
        @id = data["data"]["id"]
      else
        # put
      end
      self
    end

    def calendar
      calendar= if @calendar.nil?
        if @calendar_id.nil?
          raise Error.new "Event must be associated to a calendar"
        else
          @calendar_id
        end
      else
        @calendar.id
      end
    end

    ##
    # Delete the Event from the server
    # ==== Return
    # * *true* if sucessful
    # * raise Error if failure
    def delete
      @id.nil? and raise Error.new "event cannot be deleted if has not an unique identifier"
      connection.delete "/calendar/feeds/#{calendar}/private/full/#{@id}", nil,  {"If-Match" => "*"}
      true
    end

    ##
    # Fetch the specific event from Google Calendar
    # ==== Return
    # * *Event*
    def fetch
      if @calendar_id.nil?
        @calendar.nil? and raise Error.new "calendar or calendar_id must be valid in the event"
        @calendar_id = @calendar.id
      end
      data = decode_response connection.get "/calendar/feeds/#{@calendar_id}/private/full/#{@id}"
      self.class.build_event data["entry"], @calendar
    end

    class << self

      def create(params)
        event = if block_given?
          new(params, &Proc.new)
        else
          new(params)
        end
      end

      def build_event(data, calendar = nil)
        data.nil? and return Event.new

        attendees = data["gd$who"]
        attendees.nil? or attendees = attendees.inject([]) do |values, attendee| 
          if attendee.has_key?("gd$attendeeStatus")
            values << { :name   => attendee["valueString"], 
              :email  => attendee["email"], 
              :status => attendee["gd$attendeeStatus"]["value"].split("\.").last}
          end
          values
        end

        start_time = data["gd$when"][0]["startTime"]
        end_time = data["gd$when"][0]["endTime"]

        Event.new({:id => data["id"]["$t"].split("full/").last, 
                    :calendar => calendar, 
                    :title => data["title"]["$t"],
                    :description => data["content"]["$t"],
                    :location => data["gd$where"][0]["valueString"],
                    :comments => data["gd$comments"],
                    :attendees => attendees,
                    :start_time => start_time,
                    :end_time =>  end_time})
      end
    end

  end

end