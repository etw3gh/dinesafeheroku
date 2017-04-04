
class SegmentRegex
  cattr_accessor :segments 
  # regex that matches to a valid lat / lng float 
  re_lat_lng = /\-?\d+(.\d+)?/

  # regex that matches to an int
  re_int =  /\d+/

  re_alpha_num = /[^0-9a-z ]/

  @@segments = {
      :lat => re_lat_lng, 
      :lng => re_lat_lng, 
      :lim => re_int,
      :var => re_int,
      :vid => re_int,
      :search => re_alpha_num,
      :status => Regexp.union(Rails.application.config.statuses)
  }

end