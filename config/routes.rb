require_relative('restrictions.rb')

Rails.application.routes.draw do |map|
  
  ll_check = /\-?\d+(.\d+)?/
  int_check =  /\d+/
  constraint_obj = {:lat => ll_check, :lng => ll_check, :lim => int_check}

  # first level of security: restrict to home ip or a white list of client urls
  # ip and urls are stored in ENV variables and set in /config/initializers/whitelist.rb
  
  constraints Restrictions do 

    # second level of security will be segment constraints
    # ensure segments are float, int, strictly alpha, max words / max length 
    # scan for sql injection and escape any other strings


    namespace :inspections
    # a Query from populated dropdowns will have exact values
    get '/inspections' => 'inspections#get'
    get '/statuses' => 'inspections#statuses'

    # get nearby from dropdown
    # give street name, then populate street numbers
    # produce lat, lng for use in route
    # gives a list of nearby venues
    get '/byadddress' => 'inspections#byadddress'

    get '/find/:term' => 'inspections#find'
    get '/near/' => 'inspections#near'
    get '/nearsearch' => 'inspections#nearsearch'

    get '/nearby' => 'venues#nearby'
    
      get '/pho/:lat/:lng/:lim' => 'venues#pho', :constraints => constraint_obj

    get '/venue/:vid' => 'venues#get'
    get '/venues' => 'venues#all'



    get '/byaddr/:num/:street/:numvariance/:limit' => 'inspections#byaddr', :defaults => {:numvariance=>10, :limit=>20}
  
    get '/munstreets' => 'addresses#munstreets' 
    get '/mun' => 'addresses#mun'
    get '/streets' => 'addresses#streets'
    get '/numbers'=> 'addresses#numbers'


    get '/ping' => 'welcome#ping'

    root 'welcome#index'
  end

end
