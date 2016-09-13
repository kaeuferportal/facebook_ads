# frozen_string_literal: true
require 'spec_helper'

describe FacebookAds::Model do
  let(:test_class) do
    Class.new(described_class) do
      field :foo
      field :bar
    end
  end

  let(:id) { 42 }
  let(:test_model) { test_class.new(id) }

  let(:client) { double(FacebookAds::Client) }

  before do
    allow(FacebookAds).to receive(:client).and_return(client)
  end

  describe '.field' do
    it 'creates a round-tripping accessor' do
      expected = 'foo'
      test_model.foo = expected
      expect(test_model.foo).to eql expected
    end
  end

  describe '#fetch' do
    let(:fetch_fields) { ['foo'] }
    let(:response) { {} }
    subject { test_model.fetch(fetch_fields) }

    before do
      allow(client).to receive(:get).and_return(response)
    end

    it 'queries the data of the correct object' do
      expect(client).to receive(:get).with(id, anything)
      subject
    end

    it 'queries the specified field from the object' do
      expect(client)
        .to receive(:get).with(anything, params: { fields: fetch_fields.first })
      subject
    end

    describe 'deserialization' do
      let(:foo_value) { 'A string' }
      let(:response) { { 'foo' => foo_value } }

      it 'populates the value of foo' do
        subject
        expect(test_model.foo).to eql foo_value
      end

      # Not going to be exhaustive here
      # but at least check one other type than String
      context 'value is an integer' do
        let(:foo_value) { 1337 }

        it 'populates the value of foo' do
          subject
          expect(test_model.foo).to eql foo_value
        end
      end

      describe 'custom field types' do
        let(:converted_value) { double('converted value') }
        let(:converter) { double('Converter', from_json: converted_value) }
        let(:test_class) do
          Class.new(described_class) do
            field :foo, type: :bar
          end
        end

        before do
          allow(FacebookAds::JsonConverter)
            .to receive(:for).and_return(converter)
        end

        it 'acquires the correct kind of converter' do
          expect(FacebookAds::JsonConverter)
            .to receive(:for).with(:bar).and_return(converter)
          subject
        end

        it 'populates the value of foo with the converted value' do
          subject
          expect(test_model.foo).to eql converted_value
        end
      end

      context 'response contains unknown fields' do
        let(:response) { { 'foo' => foo_value, 'unknown' => 'baz' } }

        it 'populates the value of foo' do
          subject
          expect(test_model.foo).to eql foo_value
        end
      end
    end

    context 'calling without an array' do
      subject { test_model.fetch(fetch_fields.first) }

      it 'queries the specified field from the object' do
        expect(client)
          .to receive(:get)
          .with(anything, params: { fields: fetch_fields.first })
        subject
      end
    end

    context 'requesting multiple fields' do
      let(:fetch_fields) { %w(foo bar) }

      it 'correctly formats multiple fields' do
        expected_fields = 'foo,bar'
        expect(client)
          .to receive(:get).with(anything, params: { fields: expected_fields })
        subject
      end
    end

    context 'invalid field' do
      let(:fetch_fields) { ['invalid'] }
      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#push' do
    subject { test_model.push }
    let(:response) { {} }

    before do
      allow(client).to receive(:post).and_return(response)
    end

    it 'pushes the data to the correct object' do
      expect(client).to receive(:post).with(id, anything)
      subject
    end

    it 'sends no fields' do
      expect(client).to receive(:post).with(anything, body: {})
      subject
    end

    context 'foo set to a value' do
      let(:foo_value) { 'The value of foo' }

      # N.B. can't set foo in a before block, since inner context needs to
      # prepare the stage before we call :test_model

      it 'sends the foo field' do
        test_model.foo = foo_value
        expect(client)
          .to receive(:post).with(anything, body: { 'foo' => foo_value })
        subject
      end

      context 'foo value is a Hash' do
        let(:foo_value) { { 'key' => 'value' } }

        it 'serializes the content of foo as JSON' do
          test_model.foo = foo_value
          expect(client)
            .to receive(:post)
            .with(anything, body: { 'foo' => foo_value.to_json })
          subject
        end
      end

      context 'foo value is an Array' do
        let(:foo_value) { [1, 2] }

        it 'serializes the content of foo as JSON' do
          test_model.foo = foo_value
          expect(client)
            .to receive(:post)
            .with(anything, body: { 'foo' => foo_value.to_json })
          subject
        end
      end

      describe 'custom field types' do
        let(:converted_value) { double('converted value') }
        let(:converter) { double('Converter', to_json: converted_value) }
        let(:test_class) do
          Class.new(described_class) do
            field :foo, type: :bar
          end
        end

        before do
          allow(FacebookAds::JsonConverter)
            .to receive(:for).and_return(converter)
        end

        it 'acquires the correct kind of converter' do
          expect(FacebookAds::JsonConverter)
            .to receive(:for).with(:bar).and_return(converter)
          subject
        end

        it 'sends a converted foo value' do
          test_model.foo = foo_value
          expect(client)
            .to receive(:post)
            .with(anything, body: { 'foo' => converted_value })
          subject
        end
      end
    end
  end
end
