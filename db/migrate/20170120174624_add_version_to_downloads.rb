class AddVersionToDownloads < ActiveRecord::Migration[5.0]
  def change
    add_column :downloads, :geoversion, :integer
    add_column :downloads, :xmlversion, :integer
  end
end
