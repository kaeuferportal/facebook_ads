# frozen_string_literal: true

require 'facebook_ads/client'

models_dir = File.join(File.dirname(__FILE__), 'facebook_ads', 'models')
Dir[File.join(models_dir, '*.rb')].each do |file|
  require file
end

module FacebookAds
  class << self
    attr_accessor :access_token

    def client
      @client ||= Client.new(access_token)
    end
  end
end
