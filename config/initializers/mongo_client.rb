class MONGODB
  cattr_accessor :client, :ds  
  host = "#{ENV['OC_MONGO_IP']}:#{ENV['OC_MONGO_PORT']}"
  u = ENV['OC_DS_USER']
  p = ENV['OC_MONGO_PWD']
  @collection_name = ENV['OC_MONGO_COLLECTION']
  @@ds = ENV['OC_MONGO_DS']
  puts @@ds
  @@client = Mongo::Client.new([ host ], :database=>@@ds, :user=>u, :password=>p)
  @db = @@client.database

  def self.collections
    @db.collection_names
  end

  # using one collection with many documents for this project
  def self.collection
    @db.collection(@collection_name)
  end
  
  # finds a document (TODO) or gets all if nill
  def self.find(docname=nil)
    c = self.collection
    c.find
  end

  def self.insert(doc)
    if !doc.is_a? Hash
      raise "document is not a Hash object. You sent me: #{doc.class}"
    end
    c = self.collection
    c.insert_one(doc)
  end

  # ensures the required document structure exists
  def self.init_docs
    puts MongoDocs.doc_names
  end
end
