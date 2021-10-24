class ApplicationController < ActionController::Base
  include Pundit

  rescue_from(Pundit::NotAuthorizedError) { head 403 }

  before_action { I18n.locale = :uk }

  before_action { @status = :unknown }

  before_action { cookies.permanent.encrypted[:ikt_device_id] ||= SecureRandom.uuid }

  before_action { Rails.logger.info "  Device ID: #{cookies.encrypted[:ikt_device_id]}" }

  before_action :initialize_resource, only: :new

  before_action :build_resource, only: :create

  before_action :authorize_resource, except: :index

  before_action :authorize_collection, only: :index

  helper_method :current_user, :parent, :collection, :resource, :contest

  private

  def authorize_resource
    authorize resource
  end

  def authorize_collection
    authorize collection.is_a?(Draper::CollectionDecorator) ? collection.object : collection
  end

  def contest
    @contest ||= Contest.find params[:contest_id]
  end

  def pundit_user
    OpenStruct.new contest: contest
  end

  def logger_params
    {
      contest_id: contest.id,
      device_id: cookies.encrypted[:ikt_device_id],
      action: "#{controller_name}##{action_name}",
      status: @status,
      values: logger_values,
    }
  end

  class << self
    def log_action **params
      around_action **params do |_, action|
        action.call
      rescue StandardError => e
        CustomLogger.write logger_params.merge(exception: e)
      else
        CustomLogger.write logger_params
      end
    end
  end
end
