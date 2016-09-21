# frozen_string_literal: true
require 'facebook_ads/errors/error'

module FacebookAds
  class UnsupportedTypeError < FacebookAds::Error
    def initialize(type)
      super("Fields of type '#{type}' are not supported.")
    end
  end
end
