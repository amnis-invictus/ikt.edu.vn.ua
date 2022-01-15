class ResultsController < ApplicationController
  skip_before_action :authorize_collection, only: :index
end
