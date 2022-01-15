class SolutionMailer < ApplicationMailer
  def email solution
    @solution = solution
    mail subject: 'IKT - Розв\'язок', to: solution.user.email
  end
end
