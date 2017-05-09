# Locks use of this rails app to certain front end applications as defined by an environment variable
#
# Testing:
# For CURL requests, an api key must be specified (can be obtained by ENV var)
# Using a browser to view JSON response has been disabled,
# use Postman (https://www.getpostman.com/) for chrome or firefox
# set X-Api-Key in the headers section
#
module Restrictions
  def self.matches? request
    # 
    # if referer is null, then check for API KEY  
    # otherwise, restrict to domains used by web apps on whitelist 
    r = request.referer
    
    api_key = request.headers['X-Api-Key']

    if r.nil?
      puts '*************** NIL REFERER ****************'
      puts r 
      return api_key == Rails.configuration.api_key
    else
      puts '*************** REFERER FOUND ****************'
      puts r 
      white_list = Rails.configuration.white_list
      return r.in?(white_list)
    end     
  end
end