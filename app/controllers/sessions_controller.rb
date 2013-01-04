class SessionsController < ApplicationController
  FlickRaw.api_key = ENV['FLICKR_API_KEY']
  FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET']

  def new
    flickr = FlickRaw::Flickr.new
    token = flickr.get_request_token(:oauth_callback => URI.escape("#{request.protocol}#{request.host_with_port}/session/callback"))
    # You'll need to store the token somewhere for when the user is returned to the callback method
    # I stick mine in memcache with their session key as the cache key
    session[:request_token] = token

    @auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'write')
    redirect_to @auth_url
  end

  def callback
    flickr = FlickRaw::Flickr.new

    request_token = session[:request_token]
    oauth_token = params[:oauth_token]
    oauth_verifier = params[:oauth_verifier]

    raw_token = flickr.get_access_token(request_token['oauth_token'], request_token['oauth_token_secret'], oauth_verifier)
    # raw_token is a hash like this {"user_nsid"=>"92023420%40N00", "oauth_token_secret"=>"XXXXXX", "username"=>"boncey", "fullname"=>"Darren%20Greaves", "oauth_token"=>"XXXXXX"}
    # Use URI.unescape on the nsid and name parameters

    oauth_token = raw_token["oauth_token"]
    oauth_token_secret = raw_token["oauth_token_secret"]
    session[:access_token] = oauth_token
    session[:token_secret] = oauth_token_secret

    @user = User.find_or_create_by_oauth_token_and_oauth_token_secret(oauth_token, oauth_token_secret)
    if @user.username.blank?
      @user.update_attributes(:nsid => URI.unescape(raw_token['user_nsid']),
                              :username => raw_token['username'],
                              :fullname => URI.unescape(raw_token['fullname']))
    end

    # Store the oauth_token and oauth_token_secret in session or database
    #   and attach to a Flickraw instance before calling any methods requiring authentication

    # Attach the tokens to your flickr instance - you can now make authenticated calls with the flickr object
    flickr.access_token = oauth_token
    flickr.access_secret = oauth_token_secret

    Photo.ingest_latest_for_user(@user)
    redirect_to photos_path
  end

  def logout
    session[:access_secret] = nil
    session[:access_token] = nil
    redirect_to "/"
  end
end
