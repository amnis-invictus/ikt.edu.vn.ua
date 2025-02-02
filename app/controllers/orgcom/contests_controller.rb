module Orgcom
  class ContestsController < BaseController
    def update
      if contest.update resource_params
        redirect_to({ action: :edit }, { notice: t('.success') })
      else
        render :edit
      end
    end

    private

    def resource_params
      params.require(:contest).permit(:cities, :institutions, :contest_sites).transform_values { _1.split(/[\r\n]+/) }
    end
  end
end
