class AddTimestampToMultiple < ActiveRecord::Migration[5.0]
  def change
    add_column :multiples, :timestamp, :integer
  end
end
