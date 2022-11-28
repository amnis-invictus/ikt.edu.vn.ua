module ApplicationHelper
  def sidebar_hidden?
    controller_name == 'contests' && action_name == 'index'
  end

  def scoring_url task
    token = Rails.application.message_verifier(:scoring).generate(task.id.to_s, expires_in: 1.hour)

    "#{Rails.application.credentials.integration[:scoring]}/#{task.id}?token=#{token}"
  end
end
