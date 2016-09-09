# frozen_string_literal: true
module FacebookAds
  class Model
    class << self
      def known_fields
        @known_fields ||= Set.new
      end

      def field(name)
        name = name.to_s
        known_fields << name

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

      response = client.get(id, params: { fields: fields })
      self.fields.merge!(response)
      nil
    end

    def push
      client.post(id, body: fields)
      nil
    end

    private

    def validate_fields(fields)
      unknown_fields = fields - self.class.known_fields.to_a
      if unknown_fields.any?
        raise ArgumentError,
              "The following fields are unknown: #{unknown_fields}"
      end
    end
  end
end
