class AddNormUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :norm_url, :string
  end
end
