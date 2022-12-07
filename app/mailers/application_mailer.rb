# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@analyzer.com'
  layout 'mailer'
end
