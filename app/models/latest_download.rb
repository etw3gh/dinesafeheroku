# will be a single row that keeps track of last mod values for latest geo and xml
class LatestDownload < ApplicationRecord
  acts_as_singleton
end
