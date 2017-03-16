class NavigationController < ApplicationController
  def index
    session[:playlist_id] = nil
  end

  def about
  end

  def help
  end
end
