Rails.application.routes.draw do

  get '/inspections/:venue_id' => 'inspections#get'
  get '/find/:term' => 'inspections#find'
  get '/near/' => 'inspections#near'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
end
