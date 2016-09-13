[![Build Status](https://travis-ci.org/kaeuferportal/facebook_ads.svg?branch=master)](https://travis-ci.org/kaeuferportal/facebook_ads)
[![Code Climate](https://codeclimate.com/github/kaeuferportal/facebook_ads/badges/gpa.svg)](https://codeclimate.com/github/kaeuferportal/facebook_ads)
[![Test Coverage](https://codeclimate.com/github/kaeuferportal/facebook_ads/badges/coverage.svg)](https://codeclimate.com/github/kaeuferportal/facebook_ads/coverage)

# Facebook Ads

This is a ruby gem to communicate with [Facebook's Marketing API](https://developers.facebook.com/docs/marketing-apis),
especially the [Targeting of Ads](https://developers.facebook.com/docs/marketing-api/buying-api/targeting).

## Installation

TBD, once we are on RubyGems.org

## Configuration

First configure your access token:
````ruby
FacebookAds.configure do |config|
  config.access_token = 'your_very_secret_token'
end
````

If you prefer to load the config from a hash, you can do that too:
````ruby
FacebookAds.configure do |config|
  config_hash = YAML.load_file('my_config.yml')
  config.load_hash(config_hash)
end
````

## Usage

Then you can instantiate an empty model, which can later selectively
be populated with data. *Note*: It is neccessary to explicitly specify 
all fields that shall be retrieved.

````ruby
adset = FacebookAds::Adset.new(123456)
adset.fetch(['targeting', 'created_time'])
adset.created_time
=> 2016-09-09 14:50:39 +0200
````

After modifying your model, you can push the changes back to facebook:

````ruby
adset.push
````

## Extending the gem

The models included in this gem were basically implemented on a
"need to support" basis. However, it should be rather straightforward
to add support for further models.

Adding a new model should be as easy as inheriting from `FacebookAds::Model`
and adding the needed fields using the `field` DSL:

````ruby
class MyModel < FacebookAds::Model
  field :name
  field :created_time, type: :date_time
end
````

Since Facebook offers the schema of its models in a machine-readable
format, it should be possible to automatically generate those models
in the long term (should the need arise).

You can fetch the schema of a model using a URL like this:

````
https://graph.facebook.com/v2.7/schema/adcampaign
````

## Limitations

This gem does not (yet?) offer complete bindings for the Facebook API.
It only includes features we needed and tries to do that in an extensible
way.

### Operations

On any given model you can currently:

* **read** its fields (via the `fetch` method)
* **update** its fields (via the `push` method)

you can't:

* **create** a new instance of the model
* **delete** instances of the model

### Edges

You can't read the edges of a model. 
This means there is only access to the fields that are returned by a
`GET` request to a resource, but not to resources accessible via a
nested URL path (like `/v2.7/123/edge_resource`).
