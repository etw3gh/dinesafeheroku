class CreateLatestDownloads < ActiveRecord::Migration[5.0]
  def change
    create_table :latest_downloads do |t|
    end
  end
end

