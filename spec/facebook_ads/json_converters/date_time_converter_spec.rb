# frozen_string_literal: true
require 'spec_helper'

describe FacebookAds::DateTimeConverter do
  let(:date_time) { DateTime.new(2016, 9, 12, 11, 14, 55) }
  let(:iso_date_time) { date_time.iso8601 }

  describe '#from_json' do
    subject { described_class.from_json(iso_date_time) }

    it 'returns the parsed date time' do
      is_expected.to eql date_time
    end

    context 'source format is not ISO 8601' do
      subject { described_class.from_json(date_time.rfc2822) }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#to_json' do
    subject { described_class.to_json(date_time) }

    it 'returns the ISO 8601 formatted date time' do
      is_expected.to eql iso_date_time
    end

    context 'input is not a DateTime object' do
      subject { described_class.to_json(iso_date_time) }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
