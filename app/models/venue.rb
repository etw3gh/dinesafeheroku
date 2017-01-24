class Venue < ActiveRecord::Base
    has_many :inspections
    has_one :addresses
end