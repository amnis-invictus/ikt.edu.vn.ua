module ResourceAuthorization
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError do
      @status = :not_authorized
      CustomLogger.write **logger_params
      handle_not_authorized
    end

    before_action :authorize_resource, except: :index

    before_action :authorize_collection, only: :index

    alias_method :pundit_user, :contest
  end

  def authorize_resource
    authorize resource
  end

  def authorize_collection
    authorize collection.is_a?(Draper::CollectionDecorator) ? collection.object : collection
  end

  def handle_not_authorized
    head :forbidden
  end
end
