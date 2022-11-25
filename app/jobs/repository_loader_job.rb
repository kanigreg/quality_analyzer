# frozen_string_literal: true

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find(repository_id)

    repository.fetch!

    client = Octokit::Client.new(access_token: repository.user.token)
    github_data = client.repo(repository.github_repo_id)

    repository.update!(
      name: github_data.name,
      full_name: github_data.full_name,
      language: github_data.language&.downcase
    )

    repository.mark_as_fetched!
  rescue StandardError => e
    logger.error "RepositoryLoaderJob: #{e.message}"
    repository.mark_as_failed!
  end
end
