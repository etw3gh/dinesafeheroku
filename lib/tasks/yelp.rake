namespace :yelp do

  desc "test yelp"
  task :test => :environment do
    Yelp.client.search('Vesuvio', params = { term: 'food' })
  end
end
