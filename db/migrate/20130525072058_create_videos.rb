class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :thumbnail
      t.string :provider
      t.text :embed
      t.boolean :cur_song, :default => false
      t.integer :position
      t.integer :playlist_id

      t.timestamps
    end
    add_index :videos, [:playlist_id, :created_at]
  end
end
