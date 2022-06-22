class UserMailer < ApplicationMailer
  def email user
    @user = user
    mail subject: t('.subject'), to: user.email
  end
end
