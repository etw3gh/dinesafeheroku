class NonStandardCollectionErrror < StandardError
  def initialize(msg='Collection does not belong to the list of standard collections for this application. It must belong to MongoCollections.list')
    super
  end
end