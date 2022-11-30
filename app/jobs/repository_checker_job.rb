# frozen_string_literal: true

class RepositoryCheckerJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    github_api = ApplicationContainer[:github_api]
    storage = ApplicationContainer[:storage]

    check = Repository::Check.find(check_id)
    repo = check.repository
    repo_destination = storage.repo_dest(repo)

    begin
      github_api.clone!(repo, repo_destination)

      issues, check_status = Eslint.check(repo_destination)

      check.passed = check_status.success?
      check.reference = storage.head_commit!(repo)
      check.issues.build(issues)

      check.mark_as_finished!
    rescue StandardError => e
      Rails.logger.error(e.message)
      Rollbar.error(e)

      check.mark_as_failed!
    ensure
      storage.erase!(repo)
    end
  end
end
