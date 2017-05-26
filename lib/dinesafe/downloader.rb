require 'net/http'
require 'uri'
require 'json'
require_relative('../file_helper')

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

  # downloads a file located at @url. Saved to full_path
  # determines if the file is text or binary from its file extension
  def download(full_path)
    fh = FileHelper.new
    file_mode = fh.write_mode(full_path)
    u = URI.parse(@url)
    resp = nil
    Net::HTTP.start(u.host) do |http|
        resp = http.get(u.path)
    end
    open(full_path, file_mode) do |f|
      f.puts resp.body
    end
  end


end