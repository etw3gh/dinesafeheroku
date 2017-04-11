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
    dbs.each_with_index do |d, i|
      puts "#{i} db: #{d}"
    end
    db.collection_names.each_with_index do |c, i|
      puts "#{i} collection: #{c}"
    end
    {collections: db.collection_names}
  end 
end