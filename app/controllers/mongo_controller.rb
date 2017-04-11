class MongoController < ApplicationController
  def collections
    dsadmin_count = MONGODB.dsadmin.count
    render :json => { 
      MONGODB.collections, 
      'dsadmin': {count: dsadmin_count} 
    }
  end
end
