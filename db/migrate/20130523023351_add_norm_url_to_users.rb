class AddNormUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_normurl, :string
  end
end
