class CreateNotfounds < ActiveRecord::Migration[5.0]
  def change
    if !table_exists?('notfounds')
      create_table :notfounds do |t|
        t.integer :iid
        t.integer :venue_id
        t.integer :eid
        t.string  :num
        t.integer :lo
        t.integer :hi
        t.string  :losuf
        t.string  :hisuf
        t.timestamps
      end
    end
  end
  def down
    drop_table notfounds
  end
end
