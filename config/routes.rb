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
              :testseg => 
              :search => re_alpha_num
             }

  # first level of security: restrict to home ip or a white list of client urls
  # ip and urls are stored in ENV variables and set in /config/initializers/whitelist.rb
  
  constraints Restrictions do 

    # second level of security will be segment constraints
    # ensure segments are float, int, strictly alpha, max words / max length 
    # scan for sql injection and escape any other strings


    # a Query from populated dropdowns will have exact values







    constraints(segments, :with => :myrescue) do
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
        get 'get/:vid/:lim/:status' => :get
        get 'statuses' => :statuses        
      end
    end
    def myrescue
      puts 'RESCUE HERE'
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
