class ScoringsController < ApplicationController
  include ContestAuthentication[:judge]
end
