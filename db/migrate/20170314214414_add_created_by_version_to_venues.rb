class AddCreatedByVersionToVenues < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :createdbyversion
  end
end
