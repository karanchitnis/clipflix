class AddPrivacyToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :privacy, :string, :default => "Public"
  end
end
