require_relative('constraints/request_constraints.rb')
require_relative('constraints/app_constraints.rb')
require_relative('constraints/segment_regex.rb')


# add cons
constraint_list = [Restrictions]
appContraints = Constraints.new(constraint_list)

Rails.application.routes.draw do |map|
   
  # outer contraint covers request based constraints
  constraints appContraints do 

    # inner contraint covers url segments
    constraints(SegmentRegex.segments) do
      scope path: '/venues', controller: :venues do
        get 'get/:vid' => :get
        get 'nearby/:lat/:lng/:lim/:search' => :nearby
        get 'pho/:lat/:lng/:lim' => :pho
      end
      scope path: '/inspections', controller: :inspections do
        get 'byaddr/:num/:street/:var/:lim' => :byaddr 
        get 'find/:term' => :find
        get 'get/:vid/:status' => :get
        get 'near/:lat/:lng/:lim' => :near
        get 'nearsearch' => :nearsearch
        
        
        get 'statuses' => :statuses
      end
      scope path: '/addresses', controller: :addresses do
        get 'munstreets' => :munstreets 
        get 'mun' => :mun
        get 'streets' => :streets
        get 'numbers'=> :numbers        
      end
    end
    get '/mongo' => 'welcome#mongo'
    get '/ping' => 'welcome#ping'

    
  end
  root 'welcome#index'
end
