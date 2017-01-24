class AddStreetnameToMultiple < ActiveRecord::Migration[5.0]
  def change
    add_column :multiples, :streetname, :string
  end
end
