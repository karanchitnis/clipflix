class AddNumVidsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :num_vids, :integer, :default => 0
  end
end
