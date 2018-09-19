host = Rails.env.development? ? 'localhost' : '127.0.0.1'
pwd = ENV["MXP_REDIS_PWD"]
Sidekiq.configure_server do |config|
  config.redis = { url: "redis://:mxpress@#{host}:6379/12", password: pwd, namespace: 'mxpress' }
end

Sidekiq.configure_client do |config|
    config.redis = { url: "redis://:mxpress@#{host}:6379/12", password: pwd, namespace: 'mxpress' }
end

if Rails.env == "development"
  Dir.foreach("#{Rails.root}/app/mailers") do |model_name|
    require_dependency model_name if (model_name=~/\.rb$/)
  end
end
