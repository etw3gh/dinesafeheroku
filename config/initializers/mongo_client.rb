class MONGODB
  def self.client
    host = "#{ENV['OC_MONGO_IP']}:#{ENV['OC_MONGO_PORT']}"
    u = ENV['OC_MONGO_USER']
    p = ENV['OC_MONGO_PASSWORD']
    db = ENV['OC_MONGO_DB']
    c = ENV['OC_MONGO_COLLECTION']
   
    client = Mongo::Client.new([ host ], :database=>admin, :user=>u, :password=>p)
    db = client.database = db
    db.collection_names
  end 
end