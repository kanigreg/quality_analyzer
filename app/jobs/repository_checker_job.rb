# frozen_string_literal: true

class RepositoryCheckerJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    check = Repository::Check.find(job.arguments.first)

    if check.failed? || check.issues.size.positive?
      user = check.repository.user

      mailer_attrs = { check_id: check.id, email: user.email, repo_id: check.repository.id }
      CheckMailer.with(mailer_attrs).failure_report.deliver_later
    end
  end

  def perform(check_id)
    github_api = ApplicationContainer[:github_api]
    storage = ApplicationContainer[:storage]

    repo_destination = storage.repo_dest(check_id)
    check = Repository::Check.find(check_id)
    repo = check.repository

    github_api.clone!(repo, repo_destination)

    issues, check_status =
      case repo.language
      when 'javascript'
        Eslint.check(repo_destination)
      when 'ruby'
        Rubocop.check(repo_destination)
      else
        raise "Unexpected repository language: #{repo.language}"
      end

    check.passed = check_status.success?
    check.reference = storage.head_commit!(repo_destination)
    check.issues.build(issues)

    check.mark_as_finished!
  rescue StandardError => e
    Rails.logger.error(e.message)
    Rollbar.error(e)

    check.mark_as_failed!
  ensure
    storage.erase(check_id)
  end
end
