module YoutubeWrapper
  def get_titles_for_videos(videos)
    videos.map {|video| video.title}
  end
end
