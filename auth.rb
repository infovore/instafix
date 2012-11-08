require 'rubygems'
require 'flickraw'

FlickRaw.api_key="e4be869559e326d8c88ec8682d30303e"
FlickRaw.shared_secret="80b442226aa7bb74"

token = flickr.get_request_token
auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'write')

puts "Open this url in your process to complete the authication process : #{auth_url}"
puts "Copy here the number given when you complete the process."
verify = gets.strip

begin
  flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
  login = flickr.test.login
  p login
  puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
rescue FlickRaw::FailedResponse => e
  puts "Authentication failed : #{e.msg}"
end
