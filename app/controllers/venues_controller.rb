
class VenuesController < ApplicationController
  
  def phoClause
    " venuename like '% pho %' or venuename like 'pho %' "
  end
  def phoWhere
    " where #{phoClause}"
  end

  def nearby
    lat = params[:lat]
    lng = params[:lng]
    limit = params[:limit].to_f
    results = geoloc(lat, lng, limit, phoWhere)
    render :json => results
  end 
  def pho
    result = []
    venues =  Venue.where(phoClause)
    venues.each do |v|
      a = Address.where(:id => v.address_id).first
      item = {}
      item['address'] = "#{a.num} #{a.streetname}"
      item['lat'] = a.lat
      item['lng'] = a.lng
      item['mun'] = a.mun.gsub('former Toronto', 'Downtown')
      item['name'] = v.venuename
      item['vid'] = v.id
      result.push(item)
    end
    render :json => result
  end

  # pho nearby: pho by

end