# frozen_string_literal: true
module FacebookAds
  class Configuration
    def initialize
      @config = {}
    end

    def valid?
      !access_token.nil? && !access_token.empty?
    end

    def access_token
      @config[:access_token]
    end

    def access_token=(value)
      @config[:access_token] = value
    end

    def load_hash(hash)
      hash.each do |key, value|
        @config[key.to_sym] = value
      end
    end
  end
end
