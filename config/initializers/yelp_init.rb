require 'yelp'

Yelp.client.configure do |config|
  config.consumer_key = ENV['YELP_ID']
  config.consumer_secret = ENV['YELP_SECRET']
  config.token = ENV['YELP_TOKEN']
  #config.token_secret = ENV['']
end
