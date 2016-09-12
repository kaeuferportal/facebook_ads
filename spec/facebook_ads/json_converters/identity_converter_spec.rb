# frozen_string_literal: true
require 'spec_helper'

describe FacebookAds::IdentityConverter do
  describe '#from_json' do
    let(:input) { Object.new }
    subject { described_class.from_json(input) }

    it 'returns the input value' do
      is_expected.to be input
    end
  end

  describe '#to_json' do
    let(:input) { Object.new }
    subject { described_class.to_json(input) }

    it 'returns the input value' do
      is_expected.to be input
    end
  end
end
