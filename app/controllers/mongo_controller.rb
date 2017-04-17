class MongoController < ApplicationController
  def collections
    col_count = MONGODB.collections.count

    render_obj = {}
    render_obj['collection_count'] = col_count

    MONGODB.collections.each do |c|
      render_obj[c] = {}
      docs = MONGODB.find(c)
      render_obj[c]['count'] = docs.count
      render_obj[c]['documents'] = docs
    end
    render :json => render_obj 
  end
end
