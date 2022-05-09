class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SMTP_FROM'), cc: ENV.fetch('SMTP_CC', nil)
  layout 'mailer'
end
