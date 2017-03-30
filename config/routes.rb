require_relative('restrictions.rb')

Rails.application.routes.draw do |map|
  
  # first level of security: restrict to home ip or a white list of client urls
  constraints Restrictions do 

    # second level of securits will be segment constraints


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
    
    # TODO factor out lat and lng constraints and use segments for all urls now that the . bug has been figured out
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
