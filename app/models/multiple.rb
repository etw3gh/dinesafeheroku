class Multiple < ActiveRecord::Base
    has_one :venues
    has_one :inspections
end