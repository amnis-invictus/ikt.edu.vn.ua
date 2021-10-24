class TimersController < ActionController::API
  def show
    render plain: Time.zone.now.to_f.to_s
  end
end
