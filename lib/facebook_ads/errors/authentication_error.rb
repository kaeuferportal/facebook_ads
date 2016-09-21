# frozen_string_literal: true
require 'facebook_ads/errors/error'

module FacebookAds
  class AuthenticationError < FacebookAds::Error
    def initialize(message)
      message ||= 'Authentication with Facebook failed.'
      super(message)
    end
  end
end
