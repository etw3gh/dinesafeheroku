# For initial mongo setup and connection see config/initializers/mongo_client.rb
# To perform db operatinons use the MONGODB static class in mongo_client


# Collections for User Data 
#     Venue Type: venue_type
#     Users: users

class MongoCollections
  cattr_accessor :venue_type, :users
  @@venue_type = 'venue_type'
  @@users = 'users'
  
  @collection_names = [@@venue_type, @@users]

  def self.list
    @collection_names
  end
end