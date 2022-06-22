# This controller is used only as a parent controller for Rails Admin. We don't want any logic from ApplicationController
# and the default option is `::ActionController::Base`, so it should be OK.
class AdminController < ActionController::Base # rubocop:disable Rails/ApplicationController
  before_action { I18n.locale = :en }
end
