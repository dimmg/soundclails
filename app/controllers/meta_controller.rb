class MetaController < ApplicationController
  include YoutubeWrapper

  def get_youtube_meta
    @titles = get_titles_for_query(params[:title], 10).to_json
    respond_to do |format|
      format.js {}
    end
  end

  private

  def get_titles_for_query(query, limit)
    videos = Yt::Collections::Videos.new
    videos = videos.where(q: query, safe_search: 'none').take(limit)
    get_titles_for_videos(videos)
  end
end
