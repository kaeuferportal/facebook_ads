# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'codeclimate-test-reporter'
require 'simplecov'
CodeClimate::TestReporter.start
SimpleCov.start
SimpleCov.add_filter 'spec'

require 'facebook_ads'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.allow_message_expectations_on_nil = false
  end
end
