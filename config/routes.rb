module Restrictions
  def self.matches? request
    s = request.subdomain
    d = request.domain
    
    # if referer is null, then check for IP on whitelist (home)
    # otherwise, restrict to domains used by web apps on whitelist 
    r = request.referer

    if r.nil?
      return request.remote_ip == Rails.configuration.home_ip
    else
      #return r == 'https://openciti.ca/' || r == 'https://ds6.ca/' || r == 'http://localhost:8000/'
      retrun Rails.configuration.white_list.include? r
    end
  end
end

Rails.application.routes.draw do |map|
  #constraints(:subdomain => 'dinesafe', :domain => ['herokuapp.com', 'openciti.ca']) do
  constraints Restrictions do 
    # a Query from populated dropdowns will have exact values
    get '/inspections' => 'inspections#get'
    get '/statuses' => 'inspections#statuses'

    # get nearby from dropdown
    # give street name, then populate street numbers
    # produce lat, lng for use in route
    # gives a list of nearby venues
    get '/byadddress' => 'inspections#byadddress'

    get '/pho' => 'venues#phoall'

    get '/phoby' => 'venues#nearby'
    
    get '/pho/:lat/:lng/:lim' => 'venues#pho', :constraints => {:lat => /\-?\d+(.\d+)?/, :lng => /\-?\d+(.\d+)?/, :lim => /\d+/}

    get '/find/:term' => 'inspections#find'
    get '/near/' => 'inspections#near'
    get '/nearsearch' => 'inspections#nearsearch'

    get '/test/:a/:b' => 'venues#test'

    get '/byaddr/:num/:street/:numvariance/:limit' => 'inspections#byaddr', :defaults => {:numvariance=>10, :limit=>20}
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get '/munstreets' => 'addresses#munstreets' 
    get '/mun' => 'addresses#mun'
    get '/streets' => 'addresses#streets'
    get '/numbers'=> 'addresses#numbers'
    get '/venue/:vid' => 'venues#get'
    get '/venues' => 'venues#all'
    get '/ping' => 'welcome#ping'

    root 'welcome#index'
  end

end
