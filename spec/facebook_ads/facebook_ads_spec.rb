# frozen_string_literal: true
require 'spec_helper'

describe FacebookAds do
  before do
    described_class.send(:reset_configuration!)
  end

  describe '.configure' do
    it 'passes the configuration as block parameter' do
      described_class.configure do |config|
        expect(config).to be described_class.configuration
      end
    end

    it 'resets the client after configuration' do
      described_class.configure do |config|
        config.access_token = '1'
      end

      old_client = described_class.client

      described_class.configure do |config|
        config.access_token = '2'
      end

      expect(described_class.client).not_to be old_client
    end
  end

  describe '.client' do
    subject { described_class.client }

    it 'creates a client using the configuration' do
      expect(FacebookAds::Client)
        .to receive(:new).with(described_class.configuration)
      subject
    end

    it 'returns the client' do
      client = double(FacebookAds::Client)
      allow(FacebookAds::Client).to receive(:new).and_return(client)
      is_expected.to be client
    end

    it 'creates the client only once' do
      expect(FacebookAds::Client).to receive(:new).once.and_return(double)

      # N.B. We can't use "subject" here, since RSpec would cache the result
      # and thus described_class.client would only be called once.
      described_class.client
      described_class.client
    end
  end
end
