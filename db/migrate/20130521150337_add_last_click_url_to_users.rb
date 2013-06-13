class AddLastClickUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_click_url, :string
  end
end
