# frozen_string_literal: true

class Api::ApplicationController < ApplicationController
  include WebhookConcern

  respond_to :json

  skip_before_action :verify_authenticity_token

  rescue_from WebhookNotVerified, with: :not_verified

  private

  def not_verified
    res = { error: 'Service not verified.' }
    respond_with(res, location: nil, status: :forbidden)
  end
end
