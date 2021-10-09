Rails.application.configure do
  config.assets.version = '1.0'

  config.assets.paths << Rails.root.join('node_modules')

  config.assets.precompile += %w[home.css]
end
