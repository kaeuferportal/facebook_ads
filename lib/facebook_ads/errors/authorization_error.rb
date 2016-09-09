# frozen_string_literal: true
require 'facebook_ads/errors/error'

module FacebookAds
  class AuthorizationError < FacebookAds::Error
    def initialize(message)
      message ||= 'Authentication with Facebook failed.'
      super(message)
    end
  end
end
