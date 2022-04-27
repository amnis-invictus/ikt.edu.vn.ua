Rails.application.configure do
  if Rails.env.production?
    config.action_cable.allowed_request_origins = ENV['ACTION_CABLE_ALLOWED_ORIGINS'].split ';'
  else
    config.action_cable.disable_request_forgery_protection = true
  end
end
