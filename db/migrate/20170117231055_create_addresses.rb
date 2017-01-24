# as an experiment, split up an address into Street and Address point
# A Street is the street name and municipality
# An Address point is street number, latitude and longitude
# 
# More info is available from the city provided shapefile
#

class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    if !table_exists?('addresses')
      create_table :addresses do |t|

        t.string  :streetname
        t.string  :num

        t.float   :lat
        t.float   :lng
        
        t.integer :lo
        t.integer :hi

        t.string  :losuf
        t.string  :hisuf

        t.string  :locname
        t.string  :mun
        t.timestamps
      end
      add_index :addresses, [:streetname, :num]
    end
  end
  def down
    drop_table :addresses
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