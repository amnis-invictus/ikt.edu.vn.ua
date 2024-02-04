Rails.application.config.to_prepare do
  ActiveModel::Type.register :json, JSONType
end
