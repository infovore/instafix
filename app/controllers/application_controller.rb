class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :flickr

  def require_user
    unless current_user
      redirect_to new_session_path
    end
  end

  def current_user
    return nil if session[:access_token].blank?
    @user = User.find_by_oauth_token(session[:access_token])
  end

  def flickr
    FlickRaw.api_key = FLICKR_API_KEY
    FlickRaw.shared_secret = FLICKR_SHARED_SECRET
    flickr = FlickRaw::Flickr.new
  end
end
