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
  end
end
