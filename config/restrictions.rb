module Restrictions
  @latlng_check = /\-?\d+(.\d+)?/
  @int_check =  /\d+/

  def white
    # if referer is null, then check for IP on whitelist (home)
    # otherwise, restrict to domains used by web apps on whitelist 
    r = request.referer

    if r.nil?
      return request.remote_ip == Rails.configuration.home_ip
    else
      white_list = Rails.configuration.white_list
      return r.in?(white_list)
    end      
  end

  def self.matches? request
    :lat =~ @latlng_check && white 
  end
end