# frozen_string_literal: true
require 'facebook_ads/errors/error'

module FacebookAds
  class NotConfiguredError < FacebookAds::Error
    def initialize(message = nil)
      message ||= 'The FacebookAds gem was not configured completely.'
      super(message)
    end
  end
end
