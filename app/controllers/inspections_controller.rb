class InspectionsController < ApplicationController
  def get
    json_result = {}
    json_result['inspections'] = []
    ilist = Inspection.where(:venue_id => params[:venue_id])
    ilist.each do |inspection|
      #inspection_obj = {'inspection': {}, 'venue': {}, 'address': {}}
      
      inspection_obj = {}

      venue = Venue.where(:id => inspection.venue_id).first
      inspection_obj['venue'] = venue

      address = Address.where(:id=>venue['address_id']).first
      inspection_obj['address'] = address

      inspection_obj['inspection'] = inspection

      json_result['inspections'].push(inspection_obj)
    end
    render :json => json_result
  end
  def getj
    vid = params[:venue_id]
    query = "SELECT * FROM venues v INNER JOIN inspections i ON v.eid=i.eid INNER JOIN addresses a ON a.id=v.address_id WHERE v.id=#{vid}" 
    results = ActiveRecord::Base.connection.execute(query)
    render :json => results
  end
end
