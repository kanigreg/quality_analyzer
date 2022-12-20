# frozen_string_literal: true

class RepositoryCheckerJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    check = Repository::Check.find(job.arguments.first)

    unless check.passed?
      user = check.repository.user

      mailer_attrs = { check_id: check.id, email: user.email, repo_id: check.repository.id }
      CheckMailer.with(mailer_attrs).failure_report.deliver_later
    end
  end

  def perform(check_id)
    storage = ApplicationContainer[:storage]

    check = Repository::Check.find_by(id: check_id)

    return if check.blank?

    check.start!
    repo = check.repository

    repo_destination = storage.clone!(repo, check_id)
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
    storage.erase(repo_destination)
  end
end
