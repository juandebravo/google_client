require 'rest-client'
require 'addressable/uri'

module GoogleClient
  class HttpConnection
    
    attr_accessor :headers
    attr_accessor :access_token
    attr_accessor :query_params
    attr_accessor :headers

    def initialize(uri, query_params = {}, headers = {})
      @headers = headers
      uri = URI.parse(uri)
      @host = uri.host
      @port = uri.port
      @scheme = uri.scheme
      @query_params = query_params
      @headers = headers
    end

    ##
    # Http::GET request
    #
    # ==== Parameters
    # * *path* URI path 
    # * *query_params* query parameters to be added to the request
    #
    # ==== Return
    # * Hash JSON decoded response
    def get(path, query_params = {}, headers = {})
      uri = create_uri(path, self.query_params.merge(query_params))
      RestClient.get(uri.to_s, self.headers.merge(headers)) do |response, request, result, &block|
        handle_response(response, request, result, &block)
      end
    end

    def post(path, body = {}, headers = {})
      uri = create_uri(path, {})

      _headers = self.headers.merge(headers)
      if _headers.has_key?("Content-Type") && _headers["Content-Type"].eql?("json")
        body.is_a?(Hash) and body = body.to_json
      end
      RestClient.post(uri.to_s, body, _headers) do |response, request, result, &block|
        handle_response(response, request, result, &block)
      end
    end

    def delete(path, query_params = {}, headers = {})
      uri = create_uri(path, {})
      uri = uri.to_s[0..-2]
      RestClient.delete(uri.to_s, headers.merge({:Authorization => self.headers[:Authorization]})) do |response, request, result, &block|
        handle_response(response, request, result, &block)
      end
    end

    def create_uri(path, query_params = {})
      Addressable::URI.new({:host => @host, 
                                  :port => @port, 
                                  :scheme => @scheme, 
                                  :path => path,
                                  :query => create_query(query_params)})
    end

    private

    ##
    # This method is used to handle the HTTP response
    # ==== Parameters
    # *response* HTTP response
    # *request* HTTP request
    # *result*
    def handle_response(response, request, result, &block)
      case response.code
      when 200..207
        response.return!(request, result, &block)
      when 301..307
        response.follow_redirection(request, result, &block)
      when 400
        raise BadRequestError.new(result.body)
      when 401
        raise AuthenticationError.new(result.body)
      when 404
        raise NotFoundError.new(result.body)
      when 409
        raise ConflictError.new(result.body)
      when 422
        raise Error.new(result.body)
      when 402..408,410..421,423..499
        response.return!(request, result, &block)
      when 500..599
        raise Error.new(result.body)
      else
        response.return!(request, result, &block)
      end
    end

    ##
    # ==== Parameters
    # * *query_params* query parameters to be added to the request
    #
    # ==== Return
    # * String with the parameters concatened and escaped using CGI.escape
    def create_query(query_params)
      query_params.map do |k, v| 
        "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
      end.join("&")
    end

  end

end