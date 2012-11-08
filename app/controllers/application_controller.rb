class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def require_user
    unless current_user
      redirect_to root_path
    end
  end

  def current_user
    return nil if session[:access_token].blank?
    @user = User.find_by_access_token(session[:access_token])
  end
end
