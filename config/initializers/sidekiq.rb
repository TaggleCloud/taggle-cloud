Sidekiq.configure_client do |config|
  # ENV["REDISTOGO_URL"] = 'redis://username:password@domain.com:port/' if Rails.env.development?
end