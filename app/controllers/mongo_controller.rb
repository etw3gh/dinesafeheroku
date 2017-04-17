class MongoController < ApplicationController
  def collections
    dsadmin_count = MONGODB.c.count
    render :json => {
      'dsadmin': {
        db: MONGODB.ds,
        count: dsadmin_count,
        docs: MONGODB.find
      } 
    }
  end
end
