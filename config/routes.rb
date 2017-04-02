require_relative('restrictions.rb')

Rails.application.routes.draw do |map|
  
  # regex that matches to a valid lat / lng float 
  re_lat_lng = /\-?\d+(.\d+)?/

  # regex that matches to an int
  re_int =  /\d+/

  
  re_alpha_num = /[^0-9a-z ]/

  segments = {:lat => re_lat_lng, 
              :lng => re_lat_lng, 
              :lim => re_int, 
              :vid => re_int,
              :search => re_alpha_num
             }

  # first level of security: restrict to home ip or a white list of client urls
  # ip and urls are stored in ENV variables and set in /config/initializers/whitelist.rb
  
  constraints Restrictions do 

    # second level of security will be segment constraints
    # ensure segments are float, int, strictly alpha, max words / max length 
    # scan for sql injection and escape any other strings


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



    constraints(segments) do
      scope path: '/venues', controller: :venues do
        get 'nearby/:lat/:lng/:lim/:search' => :nearby, :defaults => {:search => ''}
        get 'venue/:vid' => :get
        get 'pho/:lat/:lng/:lim' => :pho
      end
    end




    get '/byaddr/:num/:street/:numvariance/:lim' => 'inspections#byaddr', :defaults => {:numvariance => 10, :lim => 50}
  
    get '/munstreets' => 'addresses#munstreets' 
    get '/mun' => 'addresses#mun'
    get '/streets' => 'addresses#streets'
    get '/numbers'=> 'addresses#numbers'


    get '/ping' => 'welcome#ping'

    root 'welcome#index'
  end

end
