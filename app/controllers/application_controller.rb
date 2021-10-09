class ApplicationController < ActionController::Base
  before_action :initialize_resource, only: :new

  before_action :build_resource, only: :create

  helper_method :current_user, :parent, :collection, :resource
end
