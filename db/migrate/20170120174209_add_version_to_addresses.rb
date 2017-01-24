class AddVersionToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :version, :integer
  end
end
