module Restrictions
  def self.matches? request
    # if referer is null, then check for IP on whitelist (home)
    # otherwise, restrict to domains used by web apps on whitelist 
    r = request.referer
    
    api_key = request.headers['X-Api-Key']

    if r.nil?
      puts "*****no req.referer: ip: #{api_key}, home_ip: #{Rails.configuration.api_key}" 
      return api_key == Rails.configuration.api_key
    else
      white_list = Rails.configuration.white_list
      return r.in?(white_list)
    end     
  end
end