class ApplicationController < ActionController::Base
  IP_HEADERS = %w[HTTP_CLIENT_IP HTTP_X_FORWARDED_FOR REMOTE_ADDR].freeze

  include Pundit

  rescue_from Pundit::NotAuthorizedError do
    @status = :not_authorized
    CustomLogger.write **logger_params
    handle_not_authorized
  end

  before_action { I18n.locale = :uk }

  before_action { @status = :unknown }

  before_action { cookies.permanent.encrypted[:ikt_device_id] ||= SecureRandom.uuid }

  before_action { Rails.logger.info "  Device ID: #{cookies.encrypted[:ikt_device_id]}" }

  before_action :initialize_resource, only: :new

  before_action :build_resource, only: :create

  before_action :authorize_resource, except: :index

  before_action :authorize_collection, only: :index

  helper_method :judge?, :parent, :collection, :resource, :contest

  private

  def ip_addresses
    IP_HEADERS.map { request.headers[_1].presence }.compact
  end

  def authorize_resource
    authorize resource
  end

  def authorize_collection
    authorize collection.is_a?(Draper::CollectionDecorator) ? collection.object : collection
  end

  def contest
    @contest ||= Contest.available.find params[:contest_id]
  end

  alias pundit_user contest

  def logger_params
    {
      contest_id: contest.id,
      device_id: cookies.encrypted[:ikt_device_id],
      action: "#{controller_name}##{action_name}",
      status: @status,
      values: logger_values,
    }
  end

  def handle_not_authorized
    head 403
  end

  def judge?
    session[:judge_contest] == contest.id
  end

  class << self
    def log_action **params
      around_action **params do |_, action|
        action.call
      rescue StandardError => e
        CustomLogger.write **logger_params, exception: e
        raise
      else
        CustomLogger.write **logger_params
      end
    end
  end
end
