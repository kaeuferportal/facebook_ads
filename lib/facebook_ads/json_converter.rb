# frozen_string_literal: true

require 'facebook_ads/json_converters/identity_converter'
require 'facebook_ads/json_converters/date_time_converter'

require 'facebook_ads/errors/unsupported_type_error'

module FacebookAds
  class JsonConverter
    class << self
      def for(type)
        case type
        when nil
          IdentityConverter
        when :date_time
          DateTimeConverter
        else
          raise UnsupportedTypeError, type
        end
      end
    end
  end
end
