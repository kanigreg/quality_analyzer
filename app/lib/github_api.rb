# frozen_string_literal: true

class GithubApi
  class << self
    def repository!(id, user)
      client = Octokit::Client.new(access_token: user.token)
      client.repository id
    end

    def repositories(user)
      client = Octokit::Client.new(access_token: user.token, auto_paginate: true)
      response = client.repos

      [response, :success]
    rescue Octokit::Error => e
      Rails.logger.error "Failed to load github repositories. #{e.message}"
      Rollbar.error(e)

      [[], :failure]
    end

    def clone!(repo, dest)
      github_repo = Octokit::Repository.new repo.full_name
      command = "git clone #{github_repo.url} #{dest}"
      _, error_mes, status = Open3.capture3(command)

      raise "Failed to clone repo. #{error_mes}" unless status.success?
    end

    def create_hook!(repo, user)
      client = Octokit::Client.new(access_token: user.token)
      callback_url = Rails.application.routes.url_helpers.api_checks_url
      client.create_hook(
        repo.github_id,
        'web',
        { url: callback_url, content_type: 'json', secret: secret },
        { active: true }
      )
    end

    def webhook_request?(payload, request_signature)
      hexdigest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, payload)
      signature = "sha256=#{hexdigest}"

      Rack::Utils.secure_compare(signature, request_signature)
    end

    private

    def secret
      ENV.fetch('GITHUB_CLIENT_SECRET', nil)
    end
  end
end
