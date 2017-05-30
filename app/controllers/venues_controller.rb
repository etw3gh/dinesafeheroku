
class VenuesController < ApplicationController

  def get
    vid = params[:vid].to_i
    result = Venue.where(:id => vid)
    render :json => {result: result, count: result.count}
  end

  # nearby without a search clause
  def near
    lat = params[:lat]
    lng = params[:lng]
    limit = params[:lim]
    results = geoloc(lat, lng, limit)
    render :json => results
  end
  
  def nearby
    lat = params[:lat]
    lng = params[:lng]
    limit = params[:lim]
    search = params[:search].strip

    if search == '' || search.length < 3
      limit = 50
    end

    where = where(searchClause(search))
    results = geoloc(lat, lng, limit, where)
    render :json => results
  end

  def pho
    lat = params[:lat]
    lng = params[:lng]
    limit = params[:lim].to_f
    phoWhere = where(phoClause)
    results = geoloc(lat, lng, limit, phoWhere)
    render :json => results
  end

  def phoClause
    " venuename like '% pho %' or venuename like 'pho %' "
  end

  def searchClause search
    " venuename like '%#{search}%' "
  end

  def where clause
    " where #{clause}"
  end

end