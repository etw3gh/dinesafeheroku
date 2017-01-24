class CreateVenues < ActiveRecord::Migration[5.0]
  def change
    if !table_exists?('venues')
      create_table :venues do |t|  #fix error 
        t.integer  :address_id
        t.string   :venuename
        t.integer  :eid
        t.timestamps
      end

    end
  end
  def down
    drop_table :venues
  end
end