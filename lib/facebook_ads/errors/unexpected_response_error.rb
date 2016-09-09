# frozen_string_literal: true
require 'facebook_ads/errors/error'

module FacebookAds
  class UnexpectedResponseError < FacebookAds::Error
    attr_reader :response

    def initialize(response)
      @response = response
      super('The response from Facebook was in an unexpected format.')
    end
  end
end
