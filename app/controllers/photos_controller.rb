class PhotosController < ApplicationController
  before_filter :require_user
  
  def index
    @photos = current_user.photos.visible(:order => "taken_at desc")
  end

  def alter
    #render :text => params[:photos]
    params["photos"].each do |id, photo_hash|
      actual_photo = Photo.find(id)
      actual_photo.update_from_photo_hash(photo_hash)
      
      # update flickr
      actual_photo.update_on_flickr_for_user(current_user)
    end
    redirect_to photos_path
  end

  def ingest
    Photo.ingest_latest_for_user(current_user)
    redirect_to photos_path
  end
end
