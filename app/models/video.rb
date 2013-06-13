class Video < ActiveRecord::Base
  attr_accessible :cur_vid, :embed, :position, :provider, :thumbnail, :title
  belongs_to :playlist

  def add_to_playlist(title, thumbnail, provider, embed)
  	self.update_attributes :title => title, :thumbnail => thumbnail, :provider => provider, :embed => embed
  end

  def copy_vids(title, thumbnail, provider, embed)
  	self.update_attributes :title => title, :thumbnail => thumbnail, :provider => provider, :embed => embed 
  	self.save
  end

  def upd_cur_vid_attr
    #for elem in User.find(Playlist.find(self.playlist_id).user_id).playlists
	  #  elem.videos.update_all(:cur_vid => false)
	  #end
    #self.update_attribute(:cur_vid, true)
  end
end