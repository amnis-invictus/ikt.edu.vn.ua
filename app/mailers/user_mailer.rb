class UserMailer < ApplicationMailer
  def email user
    @user = user
    mail subject: 'IKT - Реєстрація', to: user.email
  end
end
