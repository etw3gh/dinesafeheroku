class InspectionsController < ApplicationController
  def get
    json_result = {}
    json_result['inspections'] = []
    
    vid = params[:venue_id]

    ilist = Inspection.where(:venue_id => vid)
    venue = Venue.where(:id => vid).first
    address = Address.where(:id=>venue['address_id']).order('version DESC').first

    json_result['name'] = venue.venuename
    json_result['address'] = "#{address.num} #{address.streetname}"
    json_result['lat'] = address.lat
    json_result['lng'] = address.lng
    json_result['mun'] = address.mun
    json_result['locname'] = address.locname

    json_result['inspections'] = ilist

    render :json => json_result
  end

  def near
    lat = params[:lat]
    lng = params[:lng]
    limit = params[:limit]

    # http://stackoverflow.com/questions/2234204/latitude-longitude-find-nearest-latitude-longitude-complex-sql-or-complex-calc
    distance_clause = "(6371 * acos(cos(radians(#{lat})) * cos(radians(lat)) * cos(radians(lng) - radians(#{lng})) + sin(radians(#{lat})) * sin(radians(lat )))) AS distance"
    nearby_query = "SELECT a.streetname, a.num, #{distance_clause} FROM addresses a INNER JOIN venues v ON v.address_id=a.id ORDER BY distance ASC LIMIT #{limit}"
    results = ActiveRecord::Base.connection.execute(nearby_query)
    render :json => {'result': results, 'count': results.count, 'query': {'lat': lat, 'lng': lng, 'limit': limit}}

  end


  def find
    term = params[:term]
    query = "SELECT * FROM venues v INNER JOIN addresses a ON v.address_id=a.id WHERE v.venuename like '% #{term} %' and a.version = (select max(version) from addresses)"
    results = ActiveRecord::Base.connection.execute(query)
    render :json => {'result': results, 'count': results.count}
  end

  # try out a direct sql join.....
  def getj
    vid = params[:venue_id]
    query = "SELECT * FROM venues v INNER JOIN inspections i ON v.eid=i.eid INNER JOIN addresses a ON a.id=v.address_id WHERE v.id=#{vid}" 
    results = ActiveRecord::Base.connection.execute(query)
    render :json => results
  end
end
