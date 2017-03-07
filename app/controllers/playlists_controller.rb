class PlaylistsController < ApplicationController
  protect_from_forgery except: :show
  include SoundcloudWrapper

  TRUE = 'true'
  FILTERS = {
    downloadable: 'downloadable',
    less_viewed: 'asc_views',
    most_viewed: 'desc_views',
    less_liked: 'asc_likes',
    most_liked: 'desc_likes'
  }

  def set_playlist
    session[:playlist_id] = params[:playlist][:id]

    redirect_to action: :show_playlist
  end

  def show_playlist
    unless session[:playlist_id]
      redirect_to controller: :home, action: :index
    end
  end

  def get_playlist
    client = init_soundcloud_client

    playlist_id = session[:playlist_id]

    if params[:status] == TRUE
      playlist_uri, tracks = apply_filter(playlist_id, params[:filter])
    else
      playlist_uri, tracks = get_playlist_uri(client, playlist_id)
    end

    respond_to do |format|
      format.js {
        @tracks = tracks
        @playlist = playlist_uri
      }
    end
  end

  private

  def get_playlist_uri(client, playlist_id)
    if playlist_id.to_i > 0
      unless $redis.get(playlist_id)
        logger.info "REDIS:: Fetching #{playlist_id}"
        playlist = client.get("/playlists/#{playlist_id}")

        normalize_track_titles(playlist.tracks)

        $redis.set(playlist_id, playlist.to_json)
      end
      playlist_uri = 'https://api.soundcloud.com/playlists/' + playlist_id
    else
      unless $redis.get(playlist_id)
        logger.info "REDIS:: Fetching #{playlist_id}"
        playlist = client.get('/resolve', url: playlist_id)

        normalize_track_titles(playlist.tracks)

        $redis.set(playlist_id, playlist.to_json)

        _playlist_uri = JSON.parse($redis.get(playlist_id))['uri']
        $redis.set(_playlist_uri, playlist.to_json)
      end

      playlist_uri = JSON.parse($redis.get(playlist_id))['uri']
    end
    return playlist_uri, nil
  end

  def get_playlist_tracks(playlist_id)
    JSON.parse($redis.get(playlist_id))['tracks']
  end


  def apply_filter(playlist_id, filter)
    case filter
    when FILTERS[:downloadable]
      playlist_uri, tracks = get_downloadable_tracks(playlist_id)
    when FILTERS[:less_viewed]
      playlist_uri, tracks = get_tracks_by_views(playlist_id, false)
    when FILTERS[:most_viewed]
      playlist_uri, tracks = get_tracks_by_views(playlist_id, true)
    when FILTERS[:less_liked]
      playlist_uri, tracks = get_tracks_by_likes(playlist_id, false)
    when FILTERS[:most_liked]
      playlist_uri, tracks = get_tracks_by_likes(playlist_id, true)
    else
      playlist_uri, tracks = nil, nil
    end

    tracks = Kaminari.paginate_array(tracks).page(params[:page]).per(10)

    return playlist_uri, tracks
  end

  def get_downloadable_tracks(playlist_id)
    _tracks = get_playlist_tracks(playlist_id)
    tracks = downloadable(_tracks)

    return nil, tracks
  end

  def get_tracks_by_views(playlist_id, reversed)
    _tracks = get_playlist_tracks(playlist_id)
    tracks = tracks_by_views(_tracks, reversed)

    return nil, tracks
  end

  def get_tracks_by_likes(playlist_id, reversed)
    _tracks = get_playlist_tracks(playlist_id)
    tracks = tracks_by_likes(_tracks, reversed)

    return nil, tracks
  end

  def normalize(string)
    string.gsub!(/\"/, '')
  end

  def normalize_track_titles(tracks)
    tracks.each do |track|
      normalize(track['title'])
    end
  end
end
