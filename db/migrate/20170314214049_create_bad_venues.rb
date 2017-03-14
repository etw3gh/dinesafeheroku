class CreateBadVenues < ActiveRecord::Migration[5.0]
  def change
    if !table_exists?('bad_venues')
      create_table :bad_venues do |t|
        t.integer  :address_id
        t.string   :venuename
        t.integer  :eid
        t.integer  :createdbyversion
        t.timestamps
      end
      add_index :bad_venues, :eid
    end
  end
  def down
    drop_table :venues
  end
end