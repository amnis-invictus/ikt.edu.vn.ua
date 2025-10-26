class UsersController < ApplicationController
  include ResourceAuthorization
  include COHVerification

  PERMITTED_PARAMS = %i[name email region city institution contest_site grade registration_secret].freeze

  before_action :coh_verify, only: :create
  log_action only: :create

  def create
    if resource.save
      @status = :success
      render :create
    else
      @status = :error
      render :new
    end
  end

  private

  attr_reader :resource

  def collection
    @collection ||= contest.users.order :id
  end

  def resource_params
    params.require(:user).permit(PERMITTED_PARAMS).merge(registration_ips: ip_addresses, device_id: @device_id,
      registration_secret_required: true, sleep_mngr_guid: params[:coh_guid])
  end

  def initialize_resource
    @resource = contest.users.build
  end

  def build_resource
    @resource = contest.users.build resource_params
  end

  def logger_values
    [
      ['reg secret', params.dig(:user, :registration_secret)],
      ['coh guid', params[:coh_guid]],
      ['coh otp', params[:coh_otp]],
      ['otp valid', @otp_valid],
      ['ip', ip_addresses],
      ['name', params.dig(:user, :name)],
      ['usr secret', resource.secret],
      ['jdg secret', resource.judge_secret],
      ['errors', resource.errors],
    ]
  end

  def handle_not_authorized
    redirect_to action: :new
  end
end
