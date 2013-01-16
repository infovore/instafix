class Photo < ActiveRecord::Base
  attr_accessible :flickr_id, :title, :description, :taglist, :is_family, :is_friend, :is_public, :thumb_url, :user_id, :taken_at
  belongs_to :user

  scope :visible, :conditions => {:is_hidden => false}
  scope :hidden, :conditions => {:is_hidden => true}

  def public_web_page
    "http://www.flickr.com/photos/#{self.user.nsid}/#{self.flickr_id}"
  end

  def update_from_photo_hash(photo_hash)
    # update attributes
    self.title = photo_hash["title"]
    self.description = photo_hash["description"]
    self.taglist = photo_hash["taglist"]

    # update hidden
    if photo_hash["is_hidden"] == "1" 
      self.is_hidden = true
    end
    self.save
  end

  def self.ingest_latest_for_user(user)
    since = 1

    if user.photos.any?
      first_photo = user.photos.sort_by(&:taken_at).first
      since = first_photo.taken_at.to_i
    end
    ingest_photos_for_user_since(user, since)
  end

  def self.ingest_all_for_user(user)
    ingest_photos_for_user_since(user,1)
  end

  def self.ingest_photos_for_user_since(user, since)
    FlickRaw.api_key = ENV['FLICKR_API_KEY']
    FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET']
    flickr = FlickRaw::Flickr.new

    size = 500
    page = 1
    photolist = []

    while size == 500 do
      results = flickr.photos.search(:user_id => user.nsid, 
                                     :machine_tags => 'uploaded:by="instagram"', 
                                     :extras => 'description,tags,url_q,date_taken',
                                     :min_taken_date => since,
                                     :per_page => 500,
                                     :page => page)
      results.each {|r| photolist << r }
      size = results.size
      page += 1
    end

    ingest_photolist_for_user(photolist, user)
  end

  def self.ingest_photolist_for_user(photolist, user)
    photolist.each do |photo|
      ingest_photo_for_user(photo, user)
    end
  end

  def self.ingest_photo_for_user(photo,user)
    find_or_create_by_flickr_id(:flickr_id => photo.id,
                                :title => photo.title,
                                :description => photo.description,
                                :taglist => photo.tags,
                                :is_family => photo.isfamily,
                                :is_friend => photo.isfriend,
                                :is_public => photo.ispublic,
                                :thumb_url => photo.url_q,
                                :user_id => user.id,
                                :taken_at => DateTime.parse(photo.datetaken))
  end

  def self.taglist_from_tags(tags)
    tags.map do |t|
      if t =~ /\s/
        "\"#{t['raw']}\""
      else
        t['raw']
      end
    end.join(" ")
  end
end
