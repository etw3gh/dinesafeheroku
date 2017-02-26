class WelcomeController < ApplicationController
  def index
    render html: 'hello'
  end
  def ping
    render :json => {status: 200, response: 'PONG'}
  end
end
