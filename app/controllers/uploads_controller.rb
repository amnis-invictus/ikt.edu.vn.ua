class UploadsController < ApplicationController
  include ResourceAuthorization

  log_action only: %i[create update]

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

  def resource
    @resource ||= build_resource
  end

  def resource_params
    params.require(:upload).permit(:secret, solutions_attributes: %i[task_id file])
      .reverse_merge(ips: ip_addresses, device_id: @device_id, contest:)
  end

  def initialize_resource
    solutions_attributes = contest.tasks.order(:id).pluck(:id).map { { task_id: _1 } }
    @resource = Upload.new contest:, solutions_attributes:
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
