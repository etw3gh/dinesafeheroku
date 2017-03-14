class BadVenue < ActiveRecord::Base
    has_one :addresses
end