# frozen_string_literal: true

class GithubApi
  class << self
    def repository(id, user)
      client = Octokit::Client.new(access_token: user.token)
      client.repository id
    end

    def repositories(user)
      client = Octokit::Client.new(access_token: user.token, auto_paginate: true)
      response = client.repositoreis

      [response, :success]
    rescue StandardError => e
      logger.error "GitHubApi: #{e.message}"

      [[], :failure]
    end
  end
end
