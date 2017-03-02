module SoundcloudWrapper
  def init_soundcloud_client
    SoundCloud.new(client_id: '2a9bfd603ea1cbd9095e6539eee69e61')
  end

  def downloadable(tracks)
    tracks.select {|k, _| k['downloadable'] == true}
  end

  def tracks_by_views(tracks, reversed)
    tracks = tracks.sort_by {|k, _| k['playback_count'] || 0}
    return tracks.reverse if reversed else tracks
  end

  def tracks_by_likes(tracks, reversed)
    tracks = tracks.sort_by {|k, _| k['favoritings_count'] || 0 }
    return tracks.reverse if reversed else tracks
  end
end
