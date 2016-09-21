# frozen_string_literal: true
require 'spec_helper'

describe FacebookAds::JsonConverter do
  describe '#for' do
    it 'returns the IdentityConverter, if no type is specified' do
      expect(described_class.for(nil)).to be FacebookAds::IdentityConverter
    end

    it 'returns the DateTimeConverter, if :date_time is specified' do
      expect(described_class.for(nil)).to be FacebookAds::IdentityConverter
    end

    it 'raises an error, if an unknown type is specified' do
      expect { described_class.for(:foobar) }
        .to raise_error(FacebookAds::UnsupportedTypeError)
    end
  end
end
