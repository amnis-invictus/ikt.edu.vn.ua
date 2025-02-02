module Orgcom
  class SessionsController < BaseController
    def show
      redirect_to contest
    end

    def destroy
      sign_out
      redirect_to contest
    end
  end
end
