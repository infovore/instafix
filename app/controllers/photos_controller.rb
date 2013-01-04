class PhotosController < ApplicationController
  before_filter :require_user
  
  def index
    @photos = current_user.photos.visible.order("taken_at DESC")
  end

  def alter
    #render :text => params[:photos]
    params["photos"].each do |id, photo_hash|
      actual_photo = Photo.find(id)
      actual_photo.update_from_photo_hash(photo_hash)
      
      # update flickr
      FlickrFixer.perform_async(id, current_user.id)
    end
    flash[:success] = "Your photos are being modified. Please check Flickr shortly to see their fixed tags."
    redirect_to photos_path
  end

  def ingest
    Photo.ingest_latest_for_user(current_user)
    flash[:success] = "Photos ingested!"
    redirect_to photos_path
  end
end
