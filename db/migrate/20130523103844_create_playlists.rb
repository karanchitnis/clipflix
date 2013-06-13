class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :name
      t.boolean :cur_play
      t.integer :position
      t.integer :user_id

      t.timestamps
    end
    add_index :playlists, [:user_id, :created_at]
  end
end
