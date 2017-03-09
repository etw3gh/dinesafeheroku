class CreateArchives < ActiveRecord::Migration[5.0]
  def change
    if !table_exists?('archives')
      create_table :archives do |t|
        t.string :filename
        t.boolean :is_geo
        t.boolean :processed
        t.datetime :startprocessing
        t.datetime :endprocessing
        t.integer :count
        t.timestamps
      end
      add_index :archives, :filename, :unique => true
    end
  end
  def down
    drop_table archivess
  end  
end
