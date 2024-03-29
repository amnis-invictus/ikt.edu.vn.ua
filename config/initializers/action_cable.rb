Rails.application.configure do
  if %w[production staging].include? Rails.env
    config.action_cable.allowed_request_origins = ENV.fetch('ACTION_CABLE_ALLOWED_ORIGINS').split(';')
  else
    config.action_cable.disable_request_forgery_protection = true
  end
end
