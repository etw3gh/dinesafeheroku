class WelcomeController < ApplicationController
  def index
    render html: 'hello'
  end
  def ping
    render :json => {status: 200, response: 'PONG'}
  end
  def mongo_collections
    render :json => MONGODB.collections
  end
end
