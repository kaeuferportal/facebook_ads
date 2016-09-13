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
    let(:access_token) { 'a secret token' }
    subject { described_class.client }

    before do
      described_class.configuration.access_token = access_token
    end

    it 'creates a client using the access token' do
      expect(FacebookAds::Client).to receive(:new).with(access_token)
      subject
    end

    it 'creates a client using the access token' do
      client = double(FacebookAds::Client)
      expect(FacebookAds::Client).to receive(:new).and_return(client)
      is_expected.to be client
    end

    it 'creates the client only once' do
      expect(FacebookAds::Client).to receive(:new).once.and_return(double)

      described_class.client
      described_class.client
    end

    context 'access token not configured' do
      let(:access_token) { nil }

      it 'raises an error' do
        expect { subject }.to raise_error(FacebookAds::NotConfiguredError)
      end
    end
  end
end
