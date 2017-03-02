class HomeController < ApplicationController
  def index
    session[:playlist_id] = nil
  end
end
