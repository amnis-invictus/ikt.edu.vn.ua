class UploadsController < ApplicationController
  before_action :build_resource, only: %i[create update], prepend: true

  rescue_from(Pundit::NotAuthorizedError) { redirect_to action: :new }

  def create
    render resource.valid? ? :edit : :new
  end

  def update
    resource.save
    render :update
  end

  private

  attr_reader :resource

  def resource_params
    params.require(:upload).permit(:secret, solutions_attributes: %i[task_id file])
  end

  def initialize_resource
    @resource = Upload.new solutions_attributes: contest.tasks.order(:id).pluck(:id).map { { task_id: _1 } }
  end

  def build_resource
    @resource = Upload.new resource_params
  end
end
