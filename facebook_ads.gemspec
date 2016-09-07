# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facebook_ads/version'

Gem::Specification.new do |spec|
  spec.name          = 'facebook_ads'
  spec.version       = FacebookAds::VERSION
  spec.authors       = ['Beko Käuferportal GmbH']
  spec.email         = ['oss@kaeuferportal.de']

  spec.summary       = "A gem to communicate with Facebook's Marketing API"
  spec.homepage      = 'https://github.com/kaeuferportal/facebook_ads'

  spec.files         = `git ls-files -z`.split("\x0")
                                        .reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.0'
  spec.add_dependency 'httparty'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
