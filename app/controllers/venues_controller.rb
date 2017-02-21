
class VenuesController < ApplicationController

  def test
    render :json => params
  end
  def index
    @venues = Venue.all
  end
  def pho
    result = []
    venues =  Venue.where("venuename like '% pho %' or venuename like 'pho %'")
    venues.each do |v|
      a = Address.where(:id => v.address_id).first
      item = {}
      item['address'] = "#{a.num} #{a.streetname}"
      item['lat'] = a.lat
      item['lng'] = a.lng
      item['mun'] = a.mun
      item['name'] = v.venuename
      item['vid'] = v.id
      result.push(item)
    end
    render :json => result
  end
end