class ProfilesController < ApplicationController

  def fb_picture
  	@graph = Koala::Facebook::API.new(current_user.oauth_token)
  	@graph.get_object("me")
  end

end