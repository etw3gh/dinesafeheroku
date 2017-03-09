require 'net/http'
require 'uri'
require 'json'

class Downloader 
  attr_accessor :url
  def initialize(u = nil)
    @url = u
  end

  def header
    connection = Faraday.new(:url => url) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
    connection.get.headers
  end


  # should be renamed as this is a generic method
=begin

e@eli76:~/railsp/dinesafe$ grep -rin check_latest lib
lib/tasks/getarchive.rake:88:    check = dl.check_latest(@latest_service)
lib/tasks/getarchive.rake:132:    check = dl.check_latest(@latest_service)
lib/tasks/downloadall.rake:24:    archive_response = downloader.check_latest(@all_archives_service)
lib/dinesafe/downloader.rb:22:  def check_latest(service_url)


=end

  def check_latest(service_url)
    uri = URI.parse(service_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(request)
    JSON.parse(res.body)
  end


  def download(domain, path)
    url = URI.parse(domain)
    puts url
    puts path
    resp = nil
    Net::HTTP.start(url.path) do |http|
        resp = http.get(path)
    end
    resp  
  end



end