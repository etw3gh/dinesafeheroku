
class YelpClient

  def client

  end
  def search(s)
    params = { term: 'food' }
    YelpClient.client.search
  end
end
