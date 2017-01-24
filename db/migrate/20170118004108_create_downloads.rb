# store the latest filenames for dinesafe (xml) or geo location (json)
class CreateDownloads < ActiveRecord::Migration[5.0]
  def change
    create_table :downloads do |t|
      t.string :latest_xml
      t.string :latest_geo
      t.boolean :xml_done
      t.boolean :geo_done
      t.timestamps
    end
  end
  def down
    drop_table downloads
  end
end
