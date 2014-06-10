class AddLastInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_title, :string
    add_column :users, :last_url, :string
    add_column :users, :last_thumburl, :string
    add_column :users, :last_width, :string
    add_column :users, :last_height, :string
    add_column :users, :last_provider, :string
    add_column :users, :last_embed, :text
  end
end
