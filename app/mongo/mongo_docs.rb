# mongodb document naming schema
# key value pair (:name_key, VALUE)
# All Docs will have value for :name_key
# All Docs will be listed as a class atribute(cattr) in this class
#
# For initial mongo setup and connection see config/initializers/mongo_client.rb
# To perform db operatinons use the MONGODB static class in mongo_client 
class MongoDocs
  cattr_accessor :venue_type, :users
  @name_key = 'docname'

  @@venue_type = 'venue_type'
  @@users = 'users'
  
  @docs = [@@venue_type, @@users]

  def self.name_key
    @name_key
  end

  def self.doc_names
    @docs
  end
end