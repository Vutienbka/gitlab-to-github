class ApplicationMailer < ActionMailer::Base
  default from: Settings.mail_default_from
  layout 'mailer'
  add_template_helper(EmailHelper)

end
