# frozen_string_literal: true
require 'facebook_ads/json_converter'

module FacebookAds
  class Model
    class << self
      def field_converters
        @field_converters ||= {}
      end

      def known_fields
        field_converters.keys
      end

      def field(name, type: nil)
        name = name.to_s
        field_converters[name] = JsonConverter.for(type)

        define_method name do
          fields[name]
        end

        define_method "#{name}=" do |value|
          fields[name] = value
        end
      end
    end

    attr_reader :id, :fields, :client

    def initialize(id, client: FacebookAds.client)
      @id = id
      @fields = {}
      @client = client
    end

    def fetch(fields)
      fields = Array(fields)
      validate_fields(fields)

      response = client.get(id, params: { fields: fields.join(',') })
      response.each do |field, value|
        converter = self.class.field_converters[field]
        next if converter.nil?
        self.fields[field] = converter.from_json(value)
      end
      nil
    end

    def push
      request = fields.map do |field, value|
        converter = self.class.field_converters[field]
        value = converter.to_json(value)

        # HTTParty will happily convert a JSON response to a hash/array,
        # but it will not convert those into JSON for a request.
        value = value.to_json if value.is_a?(Hash) || value.is_a?(Array)
        [field, value]
      end.to_h

      client.post(id, body: request)
      nil
    end

    private

    def validate_fields(fields)
      unknown_fields = fields - self.class.known_fields
      return if unknown_fields.empty?
      raise ArgumentError, "The following fields are unknown: #{unknown_fields}"
    end
  end
end
