class HomeController < ApplicationController
  skip_before_action :authorize_resource, only: :show

  layout false
end
