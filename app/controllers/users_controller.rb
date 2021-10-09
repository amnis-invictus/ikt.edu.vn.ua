class UsersController < ApplicationController
  def create
    if resource.save
      render :create
    else
      render :new
    end
  end

  private

  attr_reader :resource

  def resource_params
    params.require(:user).permit \
      :name,
      :email,
      :region,
      :city,
      :institution,
      :contest_site,
      :grade,
      :registration_secret,
      registration_ips: []
  end

  def initialize_resource
    @resource = contest.users.build
  end

  def build_resource
    @resource = contest.users.build resource_params
  end
end
