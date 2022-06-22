class SolutionMailer < ApplicationMailer
  def email solution
    @solution = solution
    mail subject: t('.subject'), to: solution.user.email
  end
end
