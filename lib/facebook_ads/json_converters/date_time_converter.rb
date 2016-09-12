# frozen_string_literal: true

module FacebookAds
  class DateTimeConverter
    class << self
      def from_json(value)
        DateTime.iso8601(value)
      end

      def to_json(value)
        unless value.respond_to?(:iso8601)
          raise ArgumentError, 'Expected a DateTime object'
        end

        value.iso8601
      end
    end
  end
end
