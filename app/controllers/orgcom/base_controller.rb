module Orgcom
  class BaseController < ApplicationController
    include ContestAuthentication[:orgcom]
  end
end
