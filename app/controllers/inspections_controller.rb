require 'net/http'
require 'uri'

class InspectionsController < ApplicationController
  def byaddr
    num = params[:num]
    street = params[:street]
    vint = params[:var].to_i
    limit = params[:lim].to_i
    address = nil
    q = nil
    acount = 0
    if num.numeric?
      nint = num.to_i
      if vint == 0
        q = "lo = #{nint} AND streetname like '#{street}%'"
      else
        q = "lo >= #{nint - vint} AND lo <= #{nint + vint} AND streetname like '#{street}%'"
      end
      address = Address.where(q)
    else
      address = Address.where("num='#{num}' AND streetname like '#{street}%'")       
    end

    if address.blank?
      render :json => {'result': 'no results', 'num': num, 'street': street, 'q': q}
    else
      begin
        acount = address.count
        a = address.first
        lat = a['lat'].to_f
        lng = a['lng'].to_f
        results = geoloc(lat, lng, limit)
        result_obj = {'result': results, 'num': num, 'street': street, 'count': acount}
        if vint > 0
          result_obj['variance'] = vint
        end
        render :json => result_obj
      rescue Exception => e
        render :json => {'num': num, 'street': street, 'lat': lat, 'lng': lng, 'e': e}
      end
        
    end
  end


  def find
    term = params[:term]
    query = %{
      SELECT * FROM venues v INNER JOIN addresses a ON v.address_id=a.id 
      WHERE v.venuename like '% #{term} %' or v.venuename like '%#{term} %'  
      AND a.version = (SELECT MAX(version) FROM addresses)
    }
    results = ActiveRecord::Base.connection.execute(query)
    render :json => {'result': results, 'count': results.count}
    
  end  

  def get
    json_result = {}
    json_result['inspections'] = []
    if params[:status].nil?
      status = 'all'
    else
      status = params[:status].downcase
    end

    vid = params[:vid]
    venue_result = Venue.where(:id => vid)
    
    if venue_result.blank?
      render :json => {status: 204, message: 'venue not found', vid: vid}
      return
    end

    venue = venue_result.first
    eid = venue['eid']
    aid = venue['address_id']
    
    ilist = []
    if status == 'all'
      ilist = Inspection.where(:eid=>eid).order(:date=>:desc)
    else
      ilist = Inspection.where(:eid=>eid, :status=>status).order(:date=>:desc)
    end
    
    address = Address.where(:id=>aid).order('version DESC').first
    json_result['address_id'] = aid
    json_result['venue_id'] = vid
    json_result['eid'] = eid
    json_result['name'] = venue.venuename
    json_result['address'] = "#{address.num} #{address.streetname}"
    json_result['lat'] = address.lat
    json_result['lng'] = address.lng
    json_result['mun'] = address.mun
    json_result['locname'] = address.locname
    json_result['bystatus'] = status
    json_result['inspections'] = ilist

    render :json => json_result
  end

  # returns all possible inspection result types
  def statuses
    render :json => Inspection.distinct.pluck(:status)
  end
  


  def islocalhost(ip)
    ip.starts_with?('10') || ip.starts_with?('127') || ip.starts_with?('172') || ip.starts_with?('192') || ip.starts_with?('localhost')
  end

  def nearsearch
    street = params[:street]
    num = params[:num]
    term = params[:term]
    qlimit = 50

    venue_query = "SELECT lat, lng FROM venues v INNER JOIN addresses a ON v.address_id=a.id 
                   WHERE 
                   v.venuename like '%#{term}%' AND a.num='#{num}' AND a.streetname like '#{street}%'  
                   AND a.version = (select max(version) from addresses)"
    venue = ActiveRecord::Base.connection.execute(venue_query).first
    
    if venue.nil? || venue.empty?
      render :json => {'result': 'no results', 'vq': venue_query, 'term': term}
      return
    end
    lat = venue['lat']
    lng = venue['lng']

    #nearby_query = "SELECT v.venuename as name, a.num || ' ' || a.streetname as address, #{distance_clause(lat,lng)} FROM addresses a INNER JOIN venues v ON v.address_id=a.id ORDER BY distance ASC LIMIT #{qlimit}"
    results = geoloc(lat,lng,qlimit)
    render :json => {'result': results, 'count': results.count, 'units': 'KM', 'query': {'lat': lat, 'lng': lng, 'limit': qlimit, 'term': term}}
    
  end

  def near
    ip = request.remote_ip
    ipapi = "http://ip-api.com/json/#{ip}"

    #default to mi pho song vu on localhost
    dlat = 43.7186761904
    dlng = -79.5075579683

    lat = params[:lat]
    lng = params[:lng]  
    
    #get lat/lng from ip 
    if !lat.numeric? || !lng.numeric?
      if islocalhost(ip)
        lat = dlat
        lng = dlng
      else 
        uri = URI.parse(ipapi)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        ipresponse = JSON.parse(response.body)
        lat = ipresponse['lat'].to_f
        lng = ipresponse['lon'].to_f
      end
    end

    limit = params[:lim]

    # add one to account for case of limit=1 and distance=0
    # in this case we'd still like to return the nearest place instead of just the current location
    if limit.numeric?
      qlimit = limit.to_i + 1
    else
      qlimit = 10
    end


    results = geoloc(lat, lng, qlimit)
    render :json => {'result': results, 'count': results.count, 'units': 'KM', 'query': {'lat': lat, 'lng': lng, 'limit': qlimit, 'ip': ip}}

  end
  

  # try out a direct sql join.....
  def getj
    vid = params[:venue_id]
    query = "SELECT * FROM venues v INNER JOIN inspections i ON v.eid=i.eid INNER JOIN addresses a ON a.id=v.address_id WHERE v.id=#{vid}" 
    results = ActiveRecord::Base.connection.execute(query)
    render :json => results
  end
end
