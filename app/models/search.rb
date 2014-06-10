class Search < ActiveRecord::Base
  attr_accessible :last_embed, :last_height, :last_normurl, :last_provider, :last_thumburl, :last_title, :last_url, :last_width
  belongs_to :user

  def update_last_search(title, norm_url, url, thumb_url, width, height, provider, embed)
  	self.update_attributes :last_title => title, :last_normurl => norm_url, 
  		:last_url => url, :last_thumburl => thumb_url, :last_width => width, 
  		:last_height => height, :last_provider => provider, :last_embed => embed
  end
end