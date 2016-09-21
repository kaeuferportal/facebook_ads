# frozen_string_literal: true

module FacebookAds
  class IdentityConverter
    class << self
      def from_json(value)
        value
      end

      def to_json(value)
        value
      end
    end
  end
end
