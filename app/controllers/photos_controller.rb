class PhotosController < ApplicationController
  before_filter :require_user
  
  def index
    @photos = current_user.photos.visible(:order => "taken_at desc")
  end

  def alter
    render :text => params[:photos]
  end
end
