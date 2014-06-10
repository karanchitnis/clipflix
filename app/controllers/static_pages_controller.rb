class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      #if current_user.provider == "facebook"
        #graph = Koala::Facebook::API.new(current_user.oauth_token)
        #@profile_path = graph.get_picture(current_user.uid)
        #CAAF6iG3tWdwBAPG1Ti2tvjStqDYnG4xIcLuT86I49j6d28G1A92rZCbxEJB9aN2yVP4Iq84AGMk7qPlHJFtnEcF8qCd6K1TMruOUyIeOn1HaBxxVHls11DgFbkDNw7xYzY6l8FZCOryEa6RbWZA      
      #end
    end
  end

  def help
  end

  def about
  end

  def contact
    @static_page = StaticPage.new
  end

  def create
    @static_page = StaticPage.create(params[:static_page])
    Suggestion.suggestion_box(@static_page).deliver
    redirect_to root_url
  end
  
end
