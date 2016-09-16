# frozen_string_literal: true
require 'spec_helper'

describe FacebookAds::Configuration do
  subject { described_class.new }

  describe '#valid?' do
    it 'is false by default' do
      expect(subject.valid?).to eq false
    end

    it 'is true after setting an access_token' do
      subject.access_token = '123'
      expect(subject.valid?).to eq true
    end

    it 'is false after setting an empty access_token' do
      subject.access_token = ''
      expect(subject.valid?).to eq false
    end
  end

  describe '#load_hash' do
    it 'populates the config using a hash' do
      subject.load_hash(access_token: '123')
      expect(subject.access_token).to eq '123'
    end

    it 'populates the config using a stringy hash' do
      subject.load_hash('access_token' => '123')
      expect(subject.access_token).to eq '123'
    end
  end
end
