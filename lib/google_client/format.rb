module GoogleClient

  module Format

    def decode_response(response)
      response = if json?
        JSON.parse(response.body)
      else
        raise Error.new "Unknow data format"
      end
    end

    def json?
      defined? @json_mode and return @json_mode
      raise Error.new "Unknown data format"
    end

  end
end