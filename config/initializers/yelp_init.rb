require 'yelp'

yelp_id = ENV['YELP_ID']
yelp_sec = ENV['YELP_SECRET']
yelp_tok = ENV['YELP_TOKEN']

puts yelp_id
puts yelp_sec
puts yelp_tok

Yelp.client.configure do |config|
  config.consumer_key = yelp_id
  config.consumer_secret = yelp_sec
  config.token = yelp_tok
  #config.token_secret = ENV['']
end
