class MONGODB
  def self.client
    host = "#{ENV['OC_MONGO_IP']}:#{ENV['OC_MONGO_PORT']}"
    u = ENV['OC_MONGO_USER']
    p = ENV['OC_MONGO_PASSWORD']
    db = ENV['OC_MONGO_DB']
    c = ENV['OC_MONGO_COLLECTION']
    ds = ENV['OC_MONGO_DS']
    client = Mongo::Client.new([ host ], :database=>db, :user=>u, :password=>p)
    #client.use(ds)
    db = client.database
    dbs = client.database_names
    puts dbs
    db.collection_names.each do |c|
      puts c
    end
    {collections: db.collection_names}
  end 
end