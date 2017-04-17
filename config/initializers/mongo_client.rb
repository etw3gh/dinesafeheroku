class MONGODB
  cattr_accessor :client, :ds, :c  
  
  host = "#{ENV['OC_MONGO_IP']}:#{ENV['OC_MONGO_PORT']}"
  u = ENV['OC_DS_USER']
  p = ENV['OC_MONGO_PWD']

  @@ds = ENV['OC_MONGO_DS']

  @@client = Mongo::Client.new([ host ], :database=>@@ds, :user=>u, :password=>p)
  @db = @@client.database

  def self.collection(name)
    if MongoCollections.list.include? name
      return @db.collection(name)
    else
      raise NonStandardCollectionErrror
    end
  end

  def self.collections
    @db.collection_names
  end

  # finds a document (TODO) or gets all if nill
  def self.find(collection, docname=nil)
    if docname.nil?
      collection.find
    else
      collection.find({@name_key => docname})
    end
  end

  # use update to add data. this is only used to init docs for now
  def self.insert(collection, doc)
    if !doc.is_a? Hash
      raise TypeError, "document is not a Hash object. You sent me: #{doc.class}"
    end
    collection.insert_one(doc)
  end

  def self.update(collection, docname, update_key, update_data)
    n = {@name_key => docname}
    u = {update_key => update_data}
    collection.update_one(n, '$set' => u)
  end

  # ensures the required db structure exists
  def self.init_collections
    MongoCollections.list.each do |col|
      Mongo::Collection.new(@db, col)
    end
  end
end
