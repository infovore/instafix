class Photo < ActiveRecord::Base
  attr_accessible :flickr_id, :title, :description, :taglist, :is_family, :is_friend, :is_public, :thumb_url, :user_id, :taken_at
  belongs_to :user

  scope :visible, :conditions => {:is_hidden => false}

  def self.ingest_latest_for_user(user)
    FlickRaw.api_key = FLICKR_API_KEY
    FlickRaw.shared_secret = FLICKR_SHARED_SECRET
    flickr = FlickRaw::Flickr.new


    photolist = flickr.photos.search(:user_id => user.nsid, :machine_tags => 'uploaded:by="instagram"', :extras => 'description,tags,url_q,date_taken')

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