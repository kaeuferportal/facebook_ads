# frozen_string_literal: true
require 'httparty'

require 'facebook_ads/errors/authentication_error'
require 'facebook_ads/errors/client_error'
require 'facebook_ads/errors/error'
require 'facebook_ads/errors/unexpected_response_error'

module FacebookAds
  class Client
    GRAPH_API = 'https://graph.facebook.com'
    API_VERSION = 'v2.7'

    GOOD_CONTENT_TYPES = ['application/json', 'text/javascript'].freeze

    def initialize(configuration)
      raise NotConfiguredError unless configuration.valid?
      @access_token = configuration.access_token
    end

    def get(path, params: {})
      response = HTTParty.get(expand_path(path),
                              headers: http_auth_header,
                              query: params)
      handle_response(response)
    end

    def post(path, body: {})
      response = HTTParty.post(expand_path(path),
                               headers: http_auth_header,
                               body: body)
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
      when 200
        return
      when 400
        raise ClientError, error_message(response)
      when 401
        raise AuthenticationError, error_message(response)
      else
        raise Error, error_message(response)
      end
    end

    def parse_as_json(response)
      unless GOOD_CONTENT_TYPES.include? response.content_type
        raise UnexpectedResponseError, response
      end

      JSON.parse(response.body)
    rescue JSON::ParserError
      raise UnexpectedResponseError, response
    end

    # Parses a Facebook error response and returns the error message
    def error_message(response)
      json = parse_as_json(response)
      json.dig('error', 'message')
    rescue UnexpectedResponseError
      summary = "Status: #{response.code}; Body: #{response.body}"
      "Could not parse error message. #{summary}"
    end
  end
end
