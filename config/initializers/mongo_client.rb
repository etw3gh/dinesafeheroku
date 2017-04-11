class MONGODB
  host = "#{ENV['OC_MONGO_IP']}:#{ENV['OC_MONGO_PORT']}"
  u = ENV['OC_DS_USER']
  p = ENV['OC_MONGO_PASSWORD']
  c = ENV['OC_MONGO_COLLECTION']
  ds = ENV['OC_MONGO_DS']
  @client = Mongo::Client.new([ host ], :database=>ds, :user=>u, :password=>p)
  
  def self.client
    puts '---------------------ds-db'
    #@client.use(:dinesafe)
    db = @client.database
    puts ">>>>>>>>>connected #{db.name}"

    db.collections.each_with_index do |c, i|
      puts "#{i} collection: #{c.name}"
    end

    {collections: db.collection_names}
  end 
end