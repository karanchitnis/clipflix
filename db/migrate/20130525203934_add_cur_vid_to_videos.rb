class AddCurVidToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :cur_vid, :boolean,  :default => false
  end
end
