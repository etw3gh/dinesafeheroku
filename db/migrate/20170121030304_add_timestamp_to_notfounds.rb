class AddTimestampToNotfounds < ActiveRecord::Migration[5.0]
  def change
    add_column :notfounds, :timestamp, :integer
    add_column :notfounds, :found, :boolean
  end
end
