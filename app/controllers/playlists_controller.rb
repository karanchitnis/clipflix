class PlaylistsController < ApplicationController

  def init_agent
    agent = Mechanize.new{|a| a.history.max_size = 10}
    agent.user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5'
    agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    agent
  end

  # GET /playlists
  # GET /playlists.json
  def index  
    @pos = 0
    if params[:name] != nil && (params[:name][0..3] == "http" || params[:name][0..2] == "www")
      client = YouTubeIt::Client.new(:dev_key => "AI39si4IGrrB9qyNNgKqtW7YKqTSxpG54pBcyVZ8wQANOPcKeDVgGDorcP9DkrxFcPsI_gW3pJ0T2oAFB3stXtaWG_hbAsdNfA")
      playlist_id = params[:name].split('=').last
      new_playlist = Playlist.new
      new_playlist.update_attributes(:name => client.playlist(playlist_id).title, :position => 1)
      new_playlist.save
      @isprelist = true
      @agent ||= init_agent
      page = @agent.get(params[:name])
      len = page.at("#watch7-playlist-length").text.to_i rescue nil
      if len == nil
        len = page.at(".first .stat-value").text.to_i
      end
      startindex = 1
      maxresults = 0
      while len - startindex > 0
        if len - startindex > 50
          maxresults = 50
        else
          maxresults = len - maxresults
        end
        playlist_vids = client.playlist(playlist_id, {'start-index' => startindex, 'max-results' => maxresults}).videos
        for vid in playlist_vids
          new_vid = new_playlist.videos.build
          title = vid.title
          norm_url = "www.youtube.com/watch?v=" + vid.media_content[0].url.split('?')[0].split('/').last
          url = vid.media_content[0].url rescue nil
          thumb_url = vid.thumbnails[0].url
          width = 560.to_s
          height = 315.to_s
          embed = '<iframe width=' +  width + ' height=' + height + ' src=' + url + ' frameborder="0" allowfullscreen></iframe>'
          new_vid.copy_vids(title, norm_url, thumb_url, "Youtube", embed)
          startindex += 1
        end
      end
      @playlists = new_playlist
    else
      current_user.update_attribute(:last_psearch, params[:name])
      @isprelist = false
      @playlists = Playlist.order(:name).where("name like ?", "%#{current_user.last_psearch}%")
      @playlists = @playlists.order("cached_votes_up DESC")
      @playlists = @playlists.where("privacy = 'Public'")
      @playlists = @playlists.paginate(:page => params[:page], :per_page => 2)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
    @playlist = Playlist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @playlist }
    end
  end

  # GET /playlists/new
  # GET /playlists/new.json
  def new
    @playlist = current_user.playlists.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @playlist }
    end
  end

  # GET /playlists/1/edit
  def edit
    @playlist = current_user.playlists.find(params[:id])
  end

  # POST /playlists
  # POST /playlists.json
  def create
    @playlist = current_user.playlists.build(params[:playlist])

    respond_to do |format|
      if @playlist.save
        format.html { redirect_to root_url, notice: 'Playlist was successfully created.' }
        format.js
      else
        format.html { redirect_to root_url, notice: 'Playlist could not be created.' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /playlists/1
  # PUT /playlists/1.json
  def update
    @playlist = current_user.playlists.find(params[:id])

    respond_to do |format|
      if @playlist.update_attributes(params[:playlist])
        format.html { redirect_to @playlist, notice: 'Playlist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_play
    cur_playlist = current_user.playlists.find(params[:id])
    cur_playlist.update_attribute(:name, params[:name])
    cur_playlist.update_attribute(:privacy, params[:privacy])
    cur_playlist.save
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end    
  end

  def like
    playlist = Playlist.find(params[:id])
    @isprelist = false
    @playlists = Playlist.order(:name).where("name like ?", "%#{current_user.last_psearch}%")
    @playlists = @playlists.order("cached_votes_up DESC")
    @playlists = @playlists.where("privacy = 'Public'")
    @playlists = @playlists.paginate(:page => params[:page], :per_page => 2)
    @user = User.find(playlist.user_id)

    current_user.likes playlist
    respond_to do |format|
      format.html
      format.js
    end
  end

  def dislike
    playlist = Playlist.find(params[:id])
    @isprelist = false
    @playlists = Playlist.order(:name).where("name like ?", "%#{current_user.last_psearch}%")
    @playlists = @playlists.order("cached_votes_up DESC")
    @playlists = @playlists.where("privacy = 'Public'")
    @playlists = @playlists.paginate(:page => params[:page], :per_page => 2)    
    @user = User.find(playlist.user_id)

    current_user.dislikes playlist
    respond_to do |format|
      format.html
      format.js
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    @playlist = current_user.playlists.find(params[:id])
    current_user.vid_count_dec_list(@playlist)
    @playlist.destroy
    
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def sort
    params[:playlist].each_with_index do |id, index|
      current_user.playlists.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def transfer_list
    copy = current_user.playlists.build
    list_to_copy = Playlist.find(params[:id])
    copy.copy_list(list_to_copy.name, list_to_copy.privacy)
    for ind_vid in list_to_copy.videos.order("position")
      copy2 = current_user.playlists.last.videos.build
      copy2.copy_vids(ind_vid.title, ind_vid.thumbnail, ind_vid.provider, ind_vid.embed)
    end
    current_user.vid_count_inc_list(list_to_copy)

    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end    
  end

  def autocomplete_list
    @playlists = Playlist.order(:name).where("name like ?", "%#{params[:term]}%")
    @playlists = @playlists.where("privacy = 'Public'")
    render json: @playlists.map(&:name)
  end
end