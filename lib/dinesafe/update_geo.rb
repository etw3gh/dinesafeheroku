require_relative('../dinesafe/downloader')
require 'json'

# refactor: jsonpath is a url not a filename
# this will break discontinued code
class UpdateGeo
  attr_accessor :geo, :verbose, :timestamp

  def initialize(jsonpath, verbose, timestamp)
    downloader = Downloader.new(jsonpath)
    @geo = downloader.get_data_object(jsonpath)

    @verbose = verbose
    @timestamp = timestamp
  end

  def process
    @geo.keys.each do |street|

      address = @geo[street]

      address.each do |apoint|
        lat = apoint['lat']
        lng = apoint['lng']

        num = apoint['num'].downcase

        lo = apoint['lo']
        hi = apoint['hi']

        los = apoint['los'].downcase
        his = apoint['his'].downcase

        loc = apoint['locname']
        mun = apoint['mun']

        streetcleaner = street.downcase.remove("'")

        a = Address.where(:streetname=>streetcleaner, :lat=>lat, :lng=>lng, :num=>num, :lo=>lo, :hi=>hi, :losuf=>los, :hisuf=>his, :mun=>mun, :locname=>loc).first_or_create(version: @timestamp)

        puts "#{num} #{street} <---> #{a.id}: locname #{loc}, lat: #{lat} lng: #{lng} saved" if @verbose
      end
    end
  end
end

=begin
  cat lib/assets/1474461890.0_geo.json | json_reformat | head -80
{
    "Brussels St": [
        {
            "lng": -79.491255597,
            "num": "5F",
            "lo": 5,
            "los": "F",
            "lat": 43.626701734,
            "his": "",
            "mun": "Etobicoke",
            "locname": "",
            "hi": 0
        },
        {
            "lng": -79.491283732,
            "num": "5E",
            "lo": 5,
            "los": "E",
            "lat": 43.626737516,
            "his": "",
            "mun": "Etobicoke",
            "locname": "",
            "hi": 0
        },
        {
            "lng": -79.491199315,
            "num": "5H",
            "lo": 5,
            "los": "H",
            "lat": 43.626625058,
            "his": "",
            "mun": "Etobicoke",
            "locname": "",
            "hi": 0
        },

=end