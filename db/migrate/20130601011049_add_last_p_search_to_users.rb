class AddLastPSearchToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_psearch, :string
  end
end
