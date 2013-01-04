class FlickrFixer
  include Sidekiq::Worker

  def self.perform(photo_id, user_id)
    photo = Photo.find(photo_id)
    user = User.find(user_id)

    FlickRaw.api_key = ENV['FLICKR_API_KEY']
    FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET']
    flickr = FlickRaw::Flickr.new
    flickr.access_token = user.oauth_token
    flickr.access_secret = user.oauth_token_secret

    flickr.photos.setMeta(:photo_id => photo.flickr_id,
                          :title => photo.title,
                          :description => photo.description)
    flickr.photos.setTags(:photo_id => photo.flickr_id,
                            :tags => photo.taglist)
  end
end
