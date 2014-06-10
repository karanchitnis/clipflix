class Playlist < ActiveRecord::Base
  attr_accessible :cur_play, :name, :position, :privacy
  belongs_to :user
  has_many :videos
  acts_as_list
  acts_as_votable

  def copy_list(name, privacy)
  	self.update_attributes :name => name, :privacy => privacy
  	self.save
  end
end