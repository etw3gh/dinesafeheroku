require_relative('restrictions.rb')
def testseg(t)
  s = ["closed", "conditional pass", "pass"]
  t.in?(s)
end
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
              :testseg => 'hello',
              :search => re_alpha_num,
              :status => Regexp.union(Rails.application.config.statuses)
             }
  
  constraints Restrictions do 

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
        get 'statuses' => :statuses        
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
