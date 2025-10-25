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
      contest_params = params.require :contest
      base_params = contest_params.permit :info
      array_params = contest_params.permit :cities, :institutions, :contest_sites
      array_params.transform_values { _1.lines chomp: true }.merge(base_params)
    end
  end
end
