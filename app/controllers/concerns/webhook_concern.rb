# frozen_string_literal: true

module WebhookConcern
  def verify_webhook!
    payload = request.body.read
    signature = request.env['HTTP_X_HUB_SIGNATURE_256']

    raise WebhookNotVerified unless GithubApi.webhook_request?(payload, signature)
  end

  class WebhookNotVerified < StandardError; end
end
