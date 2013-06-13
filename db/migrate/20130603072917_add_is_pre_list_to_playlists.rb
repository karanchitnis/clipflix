class AddIsPreListToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :boolean, :default => false
  end
end
