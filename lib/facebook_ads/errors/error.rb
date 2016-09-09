# frozen_string_literal: true
module FacebookAds
  class Error < StandardError
    def initialize(message)
      message ||= 'An unexpected error occured.'
      super(message)
    end
  end
end
