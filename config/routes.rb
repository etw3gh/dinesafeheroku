Rails.application.routes.draw do |map|

  get '/inspections/:venue_id' => 'inspections#get'
  get '/find/:term' => 'inspections#find'
  get '/near/' => 'inspections#near'
  get '/near/:term/:num/:street' => 'inspections#nearsearch'
  get '/test/:a/:b' => 'venues#test'
  get '/byaddr/:num/:street/:numvariance/:limit' => 'inspections#byaddr', :defaults => {:numvariance=>10, :limit=>20}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

end
