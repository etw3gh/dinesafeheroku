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

  def last_mod
    self.header['last-modified'].to_datetime.to_i
  end

  # returns an xml or json object by reading a remote file
  def get_data_object(service_url)
    uri = URI.parse(service_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(request)
    JSON.parse(res.body)
  end

  # downloads a binary file located at @url. Saved to full_path
  def dl(full_path)
    u = URI.parse(@url)
    resp = nil
    Net::HTTP.start(u.host) do |http|
        resp = http.get(u.path)
    end
    open(full_path, 'wb') do |f|
      f.puts resp.body
    end
  end


end