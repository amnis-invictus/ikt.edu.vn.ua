Rails.application.configure do
  if Rails.env.production?
    config.action_mailer.raise_delivery_errors = true

    config.action_mailer.default_url_options = { host: 'ikt.edu.vn.ua', protocol: :https }

    config.action_mailer.asset_host = 'https://ikt.edu.vn.ua'
  else
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

    config.action_mailer.asset_host = 'http://localhost:3000'
  end

  config.action_mailer.smtp_settings = Rails.application.credentials.smtp_settings
end
