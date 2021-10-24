class ApplicationController < ActionController::Base
  include Pundit

  rescue_from(Pundit::NotAuthorizedError) { head 403 }

  before_action { I18n.locale = :uk }

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
end
