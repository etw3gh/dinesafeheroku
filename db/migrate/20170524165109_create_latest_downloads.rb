class CreateLatestDownloads < ActiveRecord::Migration[5.0]
  def change
    create_table :latest_downloads do |t|
      t.integer :lastmodxml
      t.integer :lastmodgeo
      t.string  :md5xml
      t.string  :md5geo
    end
  end
end