# mongodb document naming schema
# key value pair (:name_key, VALUE)
# All Docs will have value for :name_key
# All Docs will be listed as a class atribute(cattr) in this module
module MongoDocs
  cattr_accessor :name_key, :venue_type, :users
  @name_key = 'docname'
  @@venue_type = 'venue_type'
  @@users = 'users'

  def self name_key
    @name_key
  end
  def list_names
    MONGODB.collection.class_variables
  end
end