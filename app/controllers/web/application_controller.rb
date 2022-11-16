# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include AuthConcern

  rescue_from NotAuthenticated, with: :user_not_authenticated

  private

  def user_not_authenticated
    redirect_to root_path, alert: t('web.auth.not_authenticated')
  end
end
