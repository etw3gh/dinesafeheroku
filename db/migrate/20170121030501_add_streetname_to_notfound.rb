class AddStreetnameToNotfound < ActiveRecord::Migration[5.0]
  def change
    add_column :notfounds, :streetname, :string
  end
end
