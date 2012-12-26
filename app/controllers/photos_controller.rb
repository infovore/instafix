class PhotosController < ApplicationController
  before_filter :require_user
  
  def index
    @photos = current_user.photos.visible(:order => "taken_at desc")
  end

  def alter
    #render :text => params[:photos]
    params["photos"].each do |id, photo_hash|
      if photo_hash["is_hidden"] == "1" 
        actual_photo = Photo.find(id)
        actual_photo.is_hidden = true
        actual_photo.save
      end
    end
  end
end
