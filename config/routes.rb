require_relative('constraints/request_constraints.rb')
require_relative('constraints/app_constraints.rb')
require_relative('constraints/request_constraints.rb')


# add cons
constraint_list = [Restrictions]
appContraints = Constraints.new(constraint_list)

Rails.application.routes.draw do |map|
   
  # outer contraint covers request based constraints
  constraints appContraints do 

    # inner contraint covers url segments
    constraints(segments) do
      scope path: '/venues', controller: :venues do
        get 'nearby/:lat/:lng/:lim/:search' => :nearby, :defaults => {:search => ''}
        get 'get/:vid' => :get
        get 'pho/:lat/:lng/:lim' => :pho
      end
      scope path: '/inspections', controller: :inspections do
        get 'find/:term' => :find
        get 'near/:lat/:lng' => :near
        get 'nearsearch' => :nearsearch
        get 'byadddress' => :byadddress
        get 'get/:vid/:status' => :get
        get 'statuses' => :statuses, :defaults => {:status => 'all'}        
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
