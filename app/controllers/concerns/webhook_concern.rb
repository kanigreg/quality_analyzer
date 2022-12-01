# frozen_string_literal: true

module WebhookConcern
  def verify_webhook!
    github_api = ApplicationContainer[:github_api]
    payload = request.body.read
    signature = request.env['HTTP_X_HUB_SIGNATURE_256']

    raise WebhookNotVerified unless github_api.webhook_request?(payload, signature)
  end

  class WebhookNotVerified < StandardError; end
end
