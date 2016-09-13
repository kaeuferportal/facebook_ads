# frozen_string_literal: true

require 'facebook_ads/client'
require 'facebook_ads/configuration'
require 'facebook_ads/errors/not_configured_error'

models_dir = File.join(File.dirname(__FILE__), 'facebook_ads', 'models')
Dir[File.join(models_dir, '*.rb')].each do |file|
  require file
end

module FacebookAds
  class << self
    def configure
      yield configuration
      @client = nil
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def client
      raise NotConfiguredError unless configuration.configured?
      @client ||= Client.new(configuration.access_token)
    end

    private

    # N.B. Primarily intended for our specs
    def reset_configuration!
      @configuration = nil
      @client = nil
    end
  end
end
