class AddCurPlayToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :cur_play, :boolean, :default => false
  end
end
