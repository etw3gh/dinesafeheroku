class MongoController < ApplicationController
  def collections
    dsadmin_count = MONGODB.dsadmin.count
    render :json => {
      'collections': MONGODB.collections, 
      'dsadmin': {
        db: MONGODB.ds,
        count: dsadmin_count
      } 
    }
  end
end
