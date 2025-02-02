module Orgcom
  class UsersController < BaseController
    def create
      if resource.save
        redirect_to action: :index
      else
        render :new
      end
    end

    def update
      if resource.update resource_params
        render :update
      else
        render :edit
      end
    end

    private

    def collection
      @collection ||= contest.users.order :id
    end

    def resource
      @resource ||= contest.users.find params[:id]
    end

    def initialize_resource
      @resource = contest.users.build absent: true
    end

    def build_resource
      @resource = contest.users.build resource_params.merge(absent: true)
    end

    def resource_params
      params.require(:user).permit(::UsersController::PERMITTED_PARAMS)
    end
  end
end
