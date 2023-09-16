Rails.application.configure do
  case Rails.env
  when 'production', 'staging'
    host = ENV.fetch 'APPLICATION_HOST'
    config.action_mailer.smtp_settings = Rails.application.credentials.smtp_settings
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = { host:, protocol: :https }
    config.action_mailer.asset_host = "https://#{host}"
  when 'development'
    config.action_mailer.delivery_method = :letter_opener
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    config.action_mailer.asset_host = 'http://localhost:3000'
  end
end
