class VideosController < ApplicationController

  def download
    agent = Mechanize.new
    agent.pluggable_parser.default = Mechanize::Download
    agent.get(ViddlRb.get_urls("http://www.youtube.com/watch?v=QH2-TGUlwu4").first).save_as('Downloads/hihi.mp4')
  end

  def search_to_list
  	video = Playlist.find(params[:id]).videos.build(params[:video])
  	title = current_user.searches.last.last_title rescue nil
  	thumbnail = current_user.searches.last.last_thumburl rescue nil
  	provider = current_user.searches.last.last_provider rescue nil
  	embed = current_user.searches.last.last_embed rescue nil
  	
  	video.add_to_playlist(title, thumbnail, provider, embed)
    @cur_playlist = Playlist.find(params[:id])
    current_user.vid_count_inc
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def display_list_vids
    current_user.playlists.update_all(:cur_play => false)
    @cur_playlist = Playlist.find(params[:id])
    @cur_playlist.update_attribute :cur_play, true
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def display_other_vids
    @other_vids = Playlist.find(params[:id]).videos.order("position")
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def set_main_vid
    vid_to_play = Video.find(params[:id])
    vid_to_play.upd_cur_vid_attr
    
    @title = vid_to_play.title
    @embed_link = vid_to_play.embed
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def update_vid
    Video.find(params[:id]).update_attribute(:title, params[:name])
    Video.find(params[:id]).save
    @cur_playlist = Playlist.find(Video.find(params[:id]).playlist_id)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end    
  end

  def delete_vid
    @video = Video.find(params[:id])
    @cur_playlist = Playlist.find(@video.playlist_id)
    @video.destroy
    current_user.vid_count_dec

    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def sort
    params[:video].each_with_index do |id, index|
      Playlist.find(params[:id]).videos.update_all({position: index+1}, {id: id})
    end
    render nothing: true  
  end

  def transfer_vid
    newentry = current_user.playlists.find(params[:playid]).videos.build
    video = Video.find(params[:vidid])
    newentry.copy_vids(video.title, video.thumbnail, video.provider, video.embed)
    @cur_playlist = Playlist.find(params[:playid])
    current_user.vid_count_inc
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end
end