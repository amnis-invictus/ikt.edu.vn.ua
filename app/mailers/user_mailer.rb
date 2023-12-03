class UserMailer < ApplicationMailer
  def email user
    @user = user
    I18n.with_locale(:uk) { mail subject: t('.subject'), to: user.email }
  end
end
