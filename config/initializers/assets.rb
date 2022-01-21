Rails.application.configure do
  config.assets.version = '1.0'

  config.assets.paths << Rails.root.join('node_modules')

  config.assets.precompile += %w[home.css font.css]

  config.assets.configure do |env|
    env.export_concurrent = false
  end
end
