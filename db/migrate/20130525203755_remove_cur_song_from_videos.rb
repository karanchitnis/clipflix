class RemoveCurSongFromVideos < ActiveRecord::Migration
  def up
    remove_column :videos, :cur_song
  end

  def down
    add_column :videos, :cur_song, :boolean
  end
end
