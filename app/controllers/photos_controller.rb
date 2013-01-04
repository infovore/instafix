class PhotosController < ApplicationController
  before_filter :require_user
  
  def index
    @photos = current_user.photos.visible(:order => "taken_at desc")
  end

  def alter
    #render :text => params[:photos]
    params["photos"].each do |id, photo_hash|
      actual_photo = Photo.find(id)
      # update attributes
      actual_photo.title = photo_hash["title"]
      actual_photo.description = photo_hash["description"]
      actual_photo.taglist = photo_hash["taglist"]
      # update flickr
      #flickr.photos.setMeta(:photo_id => actual_photo.flickr_id,
                            #:title => actual_photo.title,
                            #:description => actual_photo.description)
      #flickr.photo_id.setTags(:photo_id => actual_photo.flickr_id,
                              #:tags => actual_photo.taglist)
      # update hidden
      if photo_hash["is_hidden"] == "1" 
        actual_photo.is_hidden = true
      end
      actual_photo.save
    end
  end
end
