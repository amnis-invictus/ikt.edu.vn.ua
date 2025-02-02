class ApplicationController < ActionController::Base
  IP_HEADERS = %w[HTTP_CLIENT_IP HTTP_X_FORWARDED_FOR REMOTE_ADDR X-Forwarded-For X-Real-IP].freeze

  include ContestAuthentication::Helpers

  before_action { I18n.locale = :uk }

  before_action { @status = :unknown }

  before_action { @device_id = cookies.permanent.encrypted[:ikt_device_id] ||= SecureRandom.uuid }

  before_action { Rails.logger.info "  Device ID: #{@device_id}" }

  before_action :initialize_resource, only: :new

  before_action :build_resource, only: :create

  helper_method :parent, :collection, :resource, :contest

  private

  def ip_addresses
    IP_HEADERS.filter_map { request.headers[_1].presence }.map { _1.split(',').map(&:strip) }.flatten.uniq
  end

  def contest
    @contest ||= Contest.available.find params[:contest_id]
  end

  def logger_params
    {
      contest_id: contest.id,
      device_id: @device_id,
      action: "#{controller_name}##{action_name}",
      status: @status,
      values: logger_values,
    }
  end

  class << self
    def log_action(**)
      around_action(**) do |_, action|
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
