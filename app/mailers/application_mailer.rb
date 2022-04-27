class ApplicationMailer < ActionMailer::Base
  default from: ENV['SMTP_FROM'], cc: ENV['SMTP_CC']
  layout 'mailer'
end
