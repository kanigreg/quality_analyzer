# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  def failure_report
    @check_id = params[:check_id]
    @repo_id = params[:repo_id]

    mail to: params[:email]
  end
end
