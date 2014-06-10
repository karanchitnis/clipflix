class SearchesController < ApplicationController
  
  def init_agent
    agent = Mechanize.new{|a| a.history.max_size = 10}
    agent.user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5'
    agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    agent
  end

  def index
    @ret = []
    @init_chars = params[:search][0..1].downcase
    search_query = params[:search][2..params[:search].length]
    if search_query[0] == " "
      search_query = search_query[1..search_query.length]
    end
    @page_results = 15
    if @init_chars == "y:"
      client = YouTubeIt::Client.new(:dev_key => "AI39si4IGrrB9qyNNgKqtW7YKqTSxpG54pBcyVZ8wQANOPcKeDVgGDorcP9DkrxFcPsI_gW3pJ0T2oAFB3stXtaWG_hbAsdNfA")
      suggested = client.videos_by(:query => search_query, :page => 1, :per_page => @page_results)
      for elem in suggested.videos
        data = {}
        data[:title] = elem.title
        data[:norm_url] = "http://www.youtube.com/watch?v=" + elem.media_content[0].url.split("?")[0].split("/").last
        data[:url] = elem.media_content[0].url rescue nil
        data[:thumb_url] = elem.thumbnails[0].url
        data[:width] = 560
        data[:height] = 315 
        @ret << data
      end
      
    elsif @init_chars == "v:"
      video = Vimeo::Advanced::Video.new("24703d4902983740cbde0361b837a6988e709b0e", "e42360660fbbadedeb9611101d5a2d4e808238a5", :token => "b91c8e1eb86d9144c6fa7f79dba67e51", :secret => "11c13a38c1ed96279a18dcc60fbd43f0681ec723")
      suggested = video.search(search_query, { :page => "1", :per_page => @page_results.to_s, :full_response => "0", :sort => "relevance", :user_id => nil })
      for elem in suggested["videos"]["video"]
        data = {}
        data[:title] = elem["title"]
        data[:norm_url] = "https://vimeo.com/" + elem["id"]
        data[:url] = "http://player.vimeo.com/video/" + elem["id"] rescue nil
        data[:thumb_url] = video.get_thumbnail_urls(elem["id"])["thumbnails"]["thumbnail"][0]["_content"]
        data[:width] = 560
        data[:height] = 281 * 560/500
        @ret << data
      end

    elsif @init_chars == "m:"
      words = search_query.split
      search = "http://www.metacafe.com/topics/"
      str = ""
      index = 0
      while index < words.count
        if index == 0
          str += words[0]
          index += 1
        else
          str += "_" + words[index]
          index += 1
        end
      end

      @agent ||= init_agent
      page = @agent.get (search + str)
      page.search('#Catalog1 li').each do |item|
        data = {}
        data[:title] = item.at('.ItemTitle a').text
        data[:norm_url] = "http://www.metacafe.com/watch/" + + item.at('.ItemTitle a')[:href].split("/")[2] rescue nil
        data[:url] = "http://www.metacafe.com/embed/" + item.at('.ItemTitle a')[:href].split("/")[2]
        data[:thumb_url] = item.at('img')[:src]
        data[:width] = 560
        data[:height] = 248 * 560/440
        @ret << data
      end
      @ret = @ret[0..@page_results-1]
    
    elsif @init_chars == "s:"
      words = search_query.split
      search = "http://www.myspace.com/search/Videos?q="
      str = ""
      index = 0
      while index < words.count
        if index == 0
          str += words[0]
          index += 1
        else
          str += "%20" + words[index]
          index += 1
        end
      end
      str += "&sl=tp"

      @agent ||= init_agent
      page = @agent.get (search + str)
      page.search('.rowPos').each do |item|
        data = {}
        data[:title] = item.at('a img')[:alt]
        data[:norm_url] = item.at('a')[:href]
        data[:url] = "http://mediaservices.myspace.com/services/media/embed.aspx/m=" + item.at('a')[:href].split("/").last + ",t=1,mt=video"
        data[:thumb_url] = item.at('a img')[:src]
        data[:width] = 560
        data[:height] = 360 * 560/425
        @ret << data
      end
      @ret = @ret[0..@page_results-1]
=begin
    elsif @init_chars == "h:"
      words = search_query.split
      search = "http://video.search.yahoo.com/search/?ei=UTF-8&fr=screen&q="
      str = ""
      index = 0
      while index < words.count
        if index == 0
          str += words[0]
          index += 1
        else
          str += "+" + words[index]
          index += 1
        end
      end

      @agent ||= init_agent
      page = @agent.get (search + str)
      page.search('.vr').each do |item|
        data = {}
        data[:title] = item.at('h3').text
        data[:url] = item.at('a')[:href]
        data[:thumb_url] = item.at('a img')[:src]
        data[:width] = 425
        data[:height] = 360
        @ret << data
      end      
      @ret = @ret[0..@page_results-1]
=end

    elsif @init_chars == "e:"
      words = search_query.split
      search = "http://www.veoh.com/find/?query="
      str = ""
      index = 0
      while index < words.count
        if index == 0
          str += words[0]
          index += 1
        else
          str += "%20" + words[index]
          index += 1
        end
      end

      @agent ||= init_agent
      page = @agent.get (search + str)
      count = 0
      thumb = "#thumb_browse_"
      page.search('#browseList li .thumbWrapper').each do |item|
        data = {}
        id = thumb + count.to_s
        data[:title] = item.at(id)[:title]
        data[:norm_url] = item.at(id)[:href]
        data[:url] = "http://www.veoh.com/static/swf/veoh/SPL.swf?version=AFrontend.5.7.0.1396&permalinkId=" + item.at(id)[:href].split("/").last + "&player=videodetailsembedded&videoAutoPlay=0&id=anonymous"
        data[:thumb_url] = item.at(id + ' img')[:src] rescue nil
        data[:width] = 560
        data[:height] = 341 * 560/410
        @ret << data
        count += 1
      end
      @ret = @ret[0..@page_results-1]
=begin
    elsif @init_chars == "u:"
      words = search_query.split
      search = "http://www.ustream.tv/new/search?q="
      str = ""
      index = 0
      while index < words.count
        if index == 0
          str += words[0]
          index += 1
        else
          str += "%20" + words[index]
          index += 1
        end
      end

      @agent ||= init_agent
      page = @agent.get (search + str)
      page.search('.item-image').each do |item|
      if item.at('a')[:href].split("/")[1] == "recorded"
        data = {}
        data[:title] = item.at('a')[:title]
        data[:url] = "http://www.ustream.tv/embed/recorded/" + item.at('a')[:href].split("/")[2] + "?v=3&amp;wmode=direct"
        data[:thumb_url] = item.at('a img')[:src] rescue nil
        data[:width] = 480
        data[:height] = 384
        @ret << data
      end
    end
    @ret = @ret[0..@page_results-1]
=end
    else 
      embedly_api = Embedly::API.new :key => '1e88dffcdc9d40809a8dba052025f927', :user_agent => 'Mozilla/5.0 (compatible; mytestapp/1.0; karanchitnis92@gmail.com)'

      obj = embedly_api.oembed :url => params[:search], :maxwidth => 560
      if obj[0].error_code != 400
        
        #current_user.update_attribute :last_click_url, params[:search]
        @embed_title = obj[0].title
        @embed_norm_url = params[:search]
        @embed_thumbnail = obj[0].thumbnail_url
        @embed_width = 560
        @embed_height = (560/(obj[0].width)) * obj[0].height
        @embed_provider = obj[0].provider_name
        @embed_link = obj[0].html
        
        #File.open("testing1.txt", 'w') {|f| f.write(@embed_link) }
        #?autoplay=1
      end
      if current_user.searches.size > 0
        current_user.searches.first.delete
      end
      search_video = current_user.searches.build
      search_video.update_last_search(@embed_title, @embed_norm_url, "", @embed_thumbnail, @embed_width, @embed_height, @embed_provider, @embed_link)

    end
    respond_to do |format|
      format.html {redirect_to root_url}
      format.js
    end
  end

  def send_vid_data

    if current_user.searches.size > 0
      current_user.searches.first.delete
    end
    search_video = current_user.searches.build
    if params[:init_chars] == "y:"
      text = '<iframe width=' + "'" + params[:width] + "' " + 'height=' + "'" + params[:height] + "' " + 'src=' + "'" + params[:url] + "' " + 'frameborder="0" allowfullscreen></iframe>' 
      search_video.update_last_search(params[:title], params[:norm_url], params[:url], params[:thumb_url], params[:width], params[:height], "youtube", text)
    elsif params[:init_chars] == "v:"
      text = '<iframe src=' + "'" + params[:url] + "' " + 'width=' + "'" + params[:width] + "' " + 'height=' + "'" + params[:height] + "' " + 'frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
      search_video.update_last_search(params[:title], params[:norm_url], params[:url], params[:thumb_url], params[:width], params[:height], "vimeo", text)
    elsif params[:init_chars] == "m:"
      text = '<iframe src=' + "'" + params[:url] + "' " + 'width=' + "'" + params[:width] + "' " + 'height=' + "'" + params[:height] + "' " + 'allowFullScreen frameborder=0></iframe>'
      search_video.update_last_search(params[:title], params[:norm_url], params[:url], params[:thumb_url], params[:width], params[:height], "metacafe", text)
    elsif params[:init_chars] == "s:"
      text = '<embed src=' + "'" + params[:url] + "' " + 'width=' + "'" + params[:width] + "' " + 'height=' + "'" + params[:height] + "' " + 'allowFullScreen="true" type="application/x-shockwave-flash" wmode="transparent" allowScriptAccess="always"></embed>'
      search_video.update_last_search(params[:title], params[:norm_url], params[:url], params[:thumb_url], params[:width], params[:height], "myspace", text)
    elsif params[:init_chars] == "e:"
      text = '<embed src=' + "'" + params[:url] + "' " + 'type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width=' + "'" + params[:width] + "' " + "'" + 'height=' + "'" + params[:height] + "' " + 'id="veohFlashPlayerEmbed" name="veohFlashPlayerEmbed"></embed>'
      search_video.update_last_search(params[:title], params[:norm_url], params[:url], params[:thumb_url], params[:width], params[:height], "veoh", text)
    end
    #File.open("testing1.txt", 'w') {|f| f.write(search_video.last_normurl) }
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end
end