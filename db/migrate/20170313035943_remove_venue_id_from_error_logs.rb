class RemoveVenueIdFromErrorLogs < ActiveRecord::Migration[5.0]
  def change
    remove_column :multiples, :venue_id
    remove_column :notfounds, :venue_id
  end
end
