class AddUserIdToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :user_id, :integer
    add_index :searches, :user_id
  end
end
