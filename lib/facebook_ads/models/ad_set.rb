# frozen_string_literal: true
require 'facebook_ads/model'

module FacebookAds
  class AdSet < FacebookAds::Model
    field :targeting
    field :created_time
  end
end
