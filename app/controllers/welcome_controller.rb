class WelcomeController < ApplicationController
  def index
    render html: 'hello'
  end
end
