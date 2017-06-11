class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def distance_clause(lat, lng)
    km_factor = 6371
    "(#{km_factor} * acos(cos(radians(#{lat})) * cos(radians(lat)) * cos(radians(lng) - radians(#{lng})) + sin(radians(#{lat})) * sin(radians(lat )))) AS distance "
  end

  # http://stackoverflow.com/questions/2234204/latitude-longitude-find-nearest-latitude-longitude-complex-sql-or-complex-calc
  def geoloc(lat, lng, limit, where='')
    nearby_query = "SELECT v.venuename as name, v.id, v.eid, replace(a.mun, 'former Toronto', 'Downtown') as mun, a.id as address_id, a.lat, a.lng, a.num, a.lo, a.hi, a.losuf, a.hisuf, a.locname, a.version as a_version, a.created_at as a_created_at, a.updated_at as a_updated_at, a.num  || ' ' || a.streetname as address, #{distance_clause(lat,lng)} FROM addresses a INNER JOIN venues v ON v.address_id=a.id #{where} ORDER BY distance ASC LIMIT #{limit}"
    ActiveRecord::Base.connection.execute(nearby_query)
  end
end
