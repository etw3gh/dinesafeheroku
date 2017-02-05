
class VenuesController < ApplicationController

  def test
    render :json => params
  end
  def index
    @venues = Venue.all
  end
end