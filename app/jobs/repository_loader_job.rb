# frozen_string_literal: true

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find(repository_id)

    repository.fetch!

    github_api = ApplicationContainer['github_api']
    github_data = github_api.repository!(repository.github_repo_id, repository.user)

    repository.update!(
      name: github_data[:name],
      full_name: github_data[:full_name],
      language: github_data[:language]&.downcase
    )

    github_api.create_hook!(repository, repository.user)

    repository.mark_as_fetched!
  rescue StandardError => e
    Rails.logger.error e.message
    Rollbar.error(e)

    repository.mark_as_failed!
  end
end
