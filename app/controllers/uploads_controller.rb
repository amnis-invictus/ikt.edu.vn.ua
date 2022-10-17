class UploadsController < ApplicationController
  log_action only: %i[create update]
  before_action :build_resource, only: %i[create update]
  before_action :authorize_resource, except: %i[index show]

  def show
    redirect_to action: :new
  end

  def create
    if resource.valid?
      @status = :success
      render :edit
    else
      @status = :error
      render :new
    end
  end

  def update
    resource.save
    render :update
  end

  private

  attr_reader :resource

  def resource_params
    params.require(:upload).permit(:secret, solutions_attributes: %i[task_id file])
      .merge(ips: ip_addresses, device_id: @device_id, contest:)
  end

  def initialize_resource
    solutions_attributes = contest.tasks.order(:id).pluck(:id).map { { task_id: _1 } }
    @resource = Upload.new solutions_attributes:, contest:
  end

  def build_resource
    @resource = Upload.new resource_params
  end

  def logger_values
    result = [['usr secret', resource.secret], ['errors', resource.errors], ['ip', ip_addresses]]
    result << ['messages', resource.messages] if action_name == 'update'
    result
  end

  def handle_not_authorized
    redirect_to action: :new
  end
end
