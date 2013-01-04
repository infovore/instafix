# three unicorns = 3 connections
Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end
# so one sidekiq can have 7 connections
Sidekiq.configure_server do |config|
  config.redis = { :size => 5 }
end
