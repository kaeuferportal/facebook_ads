# frozen_string_literal: true
require 'facebook_ads/errors/error'

module FacebookAds
  class ClientError < FacebookAds::Error
    def initialize(message)
      message ||= 'The request to Facebook was invalid.'
      super(message)
    end
  end
end
