# frozen_string_literal: true
require 'httparty'

require 'facebook_ads/errors/authorization_error'
require 'facebook_ads/errors/error'
require 'facebook_ads/errors/unexpected_response_error'

module FacebookAds
  class Client
    GRAPH_API = 'https://graph.facebook.com'
    API_VERSION = 'v2.7'

    def initialize(access_token)
      if access_token.nil? || access_token.empty?
        raise ArgumentError, 'Please provide an access token'
      end
      @access_token = access_token
    end

    def get(path, params: {})
      response = HTTParty.get(expand_path(path),
                              headers: http_auth_header,
                              params: params)
      handle_response(response)
    end

    def post(path)
      response = HTTParty.post(expand_path(path),
                               headers: http_auth_header,
                               params: params)
      handle_response(response)
    end

    private

    def expand_path(path)
      "#{GRAPH_API}/#{API_VERSION}/#{path}"
    end

    def http_auth_header
      { Authorization: "Bearer #{@access_token}" }
    end

    def handle_response(response)
      validate_status(response)
      parse_as_json(response)
    end

    def validate_status(response)
      case response.code
      when 200..299
        return
      when 401
        raise AuthenticationError, error_message(response)
      else
        raise Error, error_message(response)
      end
    end

    def parse_as_json(response)
      unless response.headers['Content-Type'] == 'application/json'
        raise UnexpectedResponseError, response
      end

      JSON.parse(response.body)
    rescue JSON::ParserError
      raise UnexpectedResponseError, response
    end

    # Parses a Facebook error response and returns the error message
    # or nil, if the message could not be parsed
    def error_message(response)
      json = parse_as_json(response)
      json.dig('error', 'message')
    rescue UnexpectedResponseError
      nil
    end
  end
end
