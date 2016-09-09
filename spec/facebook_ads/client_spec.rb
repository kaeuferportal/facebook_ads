# frozen_string_literal: true
require 'spec_helper'

describe FacebookAds::Client do
  let(:access_token) { 'secret_token' }
  let(:client) { described_class.new(access_token) }
  let(:path) { 'test' }

  let(:response) do
    double(HTTParty::Response,
           content_type: content_type,
           body: response_body,
           code: response_status)
  end
  let(:response_status) { 200 }
  let(:content_type) { 'application/json' }
  let(:response_body) { response_json.to_json }
  let(:response_json) { Hash.new }

  it 'requires an access token' do
    expect { described_class.new('') }.to raise_error(ArgumentError)
  end

  shared_examples_for 'performs an authenticated request' do |method|
    it 'uses the access token as bearer token' do
      auth_hash = { Authorization: "Bearer #{access_token}" }
      headers_hash = { headers: auth_hash }
      expect(HTTParty)
        .to receive(method)
        .with(anything, hash_including(headers_hash))
        .and_return(response)

      subject
    end
  end

  shared_examples_for 'calls the versioned Graph API' do |method|
    def expect_on_uri(method)
      expect(HTTParty).to receive(method) do |uri, _|
        yield URI(uri)
        response
      end
    end

    it 'uses the HTTPS scheme' do
      expect_on_uri(method) { |uri| expect(uri.scheme).to eq 'https' }
      subject
    end

    it 'calls the Graph API' do
      expect_on_uri(method) do |uri|
        expect(uri.host).to eq 'graph.facebook.com'
      end
      subject
    end

    it 'calls the versioned path' do
      expect_on_uri(method) { |uri| expect(uri.path).to eq "/v2.7/#{path}" }
      subject
    end
  end

  shared_examples_for 'parses the response' do |method|
    let(:response_json) { { 'test' => 'ok' } }

    before do
      allow(HTTParty)
        .to receive(method)
        .with(any_args)
        .and_return(response)
    end

    it 'returns a parsed JSON hash' do
      is_expected.to eql response_json
    end

    context 'response is declared as text/javascript' do
      let(:content_type) { 'text/javascript' }

      it 'returns a parsed JSON hash' do
        is_expected.to eql response_json
      end
    end

    context 'response is not declared as JSON' do
      let(:content_type) { 'text/html' }

      it 'raises an error' do
        expect { subject }.to raise_error(FacebookAds::UnexpectedResponseError)
      end
    end

    context 'response is not valid JSON' do
      let(:response_body) { 'This is not a JSON response' }

      it 'raises an error' do
        expect { subject }.to raise_error(FacebookAds::UnexpectedResponseError)
      end
    end

    context 'response indicates an authentication problem' do
      let(:response_status) { 401 }
      let(:error_message) { 'Have you tried turning it off and on again?' }
      let(:response_json) { { error: { message: error_message } } }

      it_behaves_like 'handles an error response' do
        let(:expected_error_class) { FacebookAds::AuthenticationError }
      end
    end

    context 'response indicates a bad request' do
      let(:response_status) { 400 }
      let(:error_message) { 'Have you tried turning it off and on again?' }
      let(:response_json) { { error: { message: error_message } } }

      it_behaves_like 'handles an error response' do
        let(:expected_error_class) { FacebookAds::ClientError }
      end
    end

    context 'response indicates another problem' do
      let(:response_status) { 500 }
      let(:error_message) { 'Have you tried turning it off and on again?' }
      let(:response_json) { { error: { message: error_message } } }

      it_behaves_like 'handles an error response' do
        let(:expected_error_class) { FacebookAds::Error }
      end
    end
  end

  shared_examples_for 'handles an error response' do
    it 'raises the expected error' do
      expect { subject }.to raise_error(expected_error_class)
    end

    it 'shows the servers error message in the raised error' do
      expect { subject }.to raise_error(error_message)
    end

    context 'JSON response is not in expected error format' do
      let(:response_json) { { no_error: 'foobar' } }

      it 'raises the expected error' do
        expect { subject }.to raise_error(expected_error_class)
      end
    end

    context 'response is not declared as JSON' do
      let(:content_type) { 'text/html' }

      it 'raises the expected error' do
        expect { subject }.to raise_error(expected_error_class)
      end
    end

    context 'response is not JSON at all' do
      let(:response_body) { error_message }

      it 'raises the expected error' do
        expect { subject }.to raise_error(expected_error_class)
      end
    end
  end

  describe '#get' do
    subject { client.get(path) }

    it_behaves_like 'performs an authenticated request', :get
    it_behaves_like 'calls the versioned Graph API', :get
    it_behaves_like 'parses the response', :get

    describe 'params' do
      let(:params) { { key: :value } }
      subject { client.get(path, params: params) }

      it 'passes the params on to HTTParty' do
        expect(HTTParty)
          .to receive(:get)
          .with(anything, hash_including(params: params))
          .and_return(response)

        subject
      end
    end
  end

  describe '#post' do
    subject { client.post(path) }

    it_behaves_like 'performs an authenticated request', :post
    it_behaves_like 'calls the versioned Graph API', :post
    it_behaves_like 'parses the response', :post

    describe 'body' do
      let(:body) { { key: :value } }
      subject { client.post(path, body: body) }

      it 'passes the body on to HTTParty' do
        expect(HTTParty)
          .to receive(:post)
          .with(anything, hash_including(body: body))
          .and_return(response)

        subject
      end
    end
  end
end
