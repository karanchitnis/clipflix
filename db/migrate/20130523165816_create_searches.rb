class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :last_title
      t.string :last_normurl
      t.string :last_url
      t.string :last_thumburl
      t.string :last_width
      t.string :last_height
      t.string :last_provider
      t.text :last_embed

      t.timestamps
    end
  end
end
