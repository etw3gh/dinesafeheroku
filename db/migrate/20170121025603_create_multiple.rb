class CreateMultiple < ActiveRecord::Migration[5.0]
  def change
    if !table_exists?('multiples')
      create_table :multiples do |t|
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
    drop_table multiples
  end
end
