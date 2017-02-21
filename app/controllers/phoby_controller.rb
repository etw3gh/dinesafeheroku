class PhobyController < ApplicationController
  def phoClause
    " where venuename like '% pho %' or venuename like 'pho %' "
  end

  def nearby
    lat = params[:lat]
    lng = params[:lng]
    limit = params[:limit].to_f
    results = geoloc(lat, lng, qlimit, phoClause)
    render :json => results
  end 
end