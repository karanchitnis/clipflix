class RemoveCurPlayFromPlaylists < ActiveRecord::Migration
  def up
    remove_column :playlists, :cur_play
  end

  def down
    add_column :playlists, :cur_play, :boolean
  end
end
