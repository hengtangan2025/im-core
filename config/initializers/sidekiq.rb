if Rails.env == "production"
  sidekiq_url = "redis://localhost:6379/1"

  Sidekiq.configure_server do |config|
    config.redis = { namespace: 'sidekiq__im_core', url: sidekiq_url }
  end
  Sidekiq.configure_client do |config|
    config.redis = { namespace: 'sidekiq__im_core', url: sidekiq_url }
  end
end