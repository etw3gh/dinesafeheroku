Rails.application.routes.draw do |map|
  
  # a Query from populated dropdowns will have exact values
  get '/inspections' => 'inspections#get', :defaults =>{:status=> 'pass', :limit =>20}

  # get nearby from dropdown
  # give street name, then populate street numbers
  # produce lat, lng for use in route
  # gives a list of nearby venues
  get '/byadddress/:lat/:lng' => 'inspections#byadddress'

  get '/pho' => 'venues#pho'
  get '/phoby' => 'venues#nearby'
  get '/find/:term' => 'inspections#find'
  get '/near/' => 'inspections#near'
  get '/near/:term/:num/:street' => 'inspections#nearsearch'
  get '/test/:a/:b' => 'venues#test'
  get '/byaddr/:num/:street/:numvariance/:limit' => 'inspections#byaddr', :defaults => {:numvariance=>10, :limit=>20}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/munstreets' => 'addresses#munstreets' 
  get '/mun' => 'addresses#mun'
  get '/streets' => 'addresses#streets'
  get '/numbers'=> 'addresses#numbers'

  root 'welcome#index'
   


end
