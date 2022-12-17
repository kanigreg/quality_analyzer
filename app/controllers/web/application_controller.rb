# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include AuthConcern
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from NotAuthenticated, with: :user_not_authenticated

  private

  def user_not_authorized
    redirect_to root_path, alert: t('access_denied')
  end

  def user_not_authenticated
    redirect_to root_path, alert: t('web.auth.not_authenticated')
  end
end
