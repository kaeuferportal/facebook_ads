[![Build Status](https://travis-ci.org/kaeuferportal/facebook_ads.svg?branch=master)](https://travis-ci.org/kaeuferportal/facebook_ads)

# Facebook Ads

This is a ruby gem to communicate with [Facebook's Marketing API](https://developers.facebook.com/docs/marketing-apis),
especially the [Targeting of Ads](https://developers.facebook.com/docs/marketing-api/buying-api/targeting).

## Installation

TBD, once we are on RubyGems.org

## Usage

First configure your access token:

````ruby
FacebookAds.access_token = 'your_very_secret_token'
````

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
  field :created_time
end
````

Since Facebook also offers the schema of its models in a machine-readable
format, it should also be possible to automatically generate those models
in the long term (should the need arise).

You can fetch the schema of a model using a URL like this:

````
https://graph.facebook.com/v2.7/schema/adcampaign
````
