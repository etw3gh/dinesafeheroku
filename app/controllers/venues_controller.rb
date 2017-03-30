
class VenuesController < ApplicationController
  
  def phoClause
    " venuename like '% pho %' or venuename like 'pho %' "
  end
  def phoWhere
    " where #{phoClause}"
  end

  def get
    vid = params[:vid].to_i
    result = Venue.where(:id => vid)
    render :json => {result: result, count: result.count} 
  end
  
  def all
    render :json => Venue.all
  end

  def pho
    lat = params[:lat]
    lng = params[:lng]
    limit = params[:lim].to_f
    results = geoloc(lat, lng, limit, phoWhere)
    render :json => results
  end 

  def nearby
    lat = params[:lat]
    lng = params[:lng]
    limit = params[:lim].to_f
    results = geoloc(lat, lng, limit, phoWhere)
    render :json => results
  end 


end