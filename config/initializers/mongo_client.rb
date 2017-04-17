class MONGODB
  cattr_accessor :client, :ds, :c  
  
  host = "#{ENV['OC_MONGO_IP']}:#{ENV['OC_MONGO_PORT']}"
  u = ENV['OC_DS_USER']
  p = ENV['OC_MONGO_PWD']
  @collection_name = ENV['OC_MONGO_COLLECTION']
  @@ds = ENV['OC_MONGO_DS']
  puts @@ds
  @@client = Mongo::Client.new([ host ], :database=>@@ds, :user=>u, :password=>p)
  @db = @@client.database

  # using one collection with a known set of documents for this project
  @@c = @db.collection(@collection_name)
  
  @name_key = MongoDocs.name_key

  def self.collections
    @db.collection_names
  end

  # finds a document (TODO) or gets all if nill
  def self.find(docname=nil)
    if docname.nil?
      @@c.find
    else
      @@c.find({@name_key => docname})
    end
  end

  def self.insert(doc)
    if !doc.is_a? Hash
      raise "document is not a Hash object. You sent me: #{doc.class}"
    end
    @@c.insert_one(doc)
  end

  # ensures the required document structure exists
  def self.init_docs
    MongoDocs.doc_names.each do |doc|
      puts doc
      d = self.find(doc)
      if d.count == 0
        self.insert({@name_key => doc})
      end
    end
  end
end

## run init statically

MONGODB.init_docs
