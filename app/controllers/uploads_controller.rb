class UploadsController < ApplicationController
  skip_before_action :initialize_resource, :build_resource

  def create
    resource.assign_attributes resource_params
    render resource.valid? ? :edit : :new
  end

  def update
    resource.assign_attributes resource_params
    resource.save
    render :update
  end

  private

  def resource_params
    params.require(:upload).permit(:secret, solutions_attributes: %i[task_id file])
  end

  def resource
    @resource ||= Upload.new solutions: contest.tasks.order(:id).map { _1.solutions.build }
  end
end
