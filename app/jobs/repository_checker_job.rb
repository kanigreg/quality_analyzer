# frozen_string_literal: true

class RepositoryCheckerJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    check = Repository::Check.find(job.arguments.first)

    return if check.finished? && check.issues.size.zero?

    user = check.repository.user

    mailer_attrs = {
      id: check.id,
      email: user.email,
      repo_id: check.repository.id
    }
    CheckMailer.with(mailer_attrs).failure_report.deliver_later
  end

  def perform(check_id)
    github_api = ApplicationContainer[:github_api]
    storage = ApplicationContainer[:storage]

    check = Repository::Check.find(check_id)
    repo = check.repository
    repo_destination = storage.repo_dest(repo)

    # FIXME: another parallel job may erase the directory before checking
    storage.erase!(check.repository)
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
    check.reference = storage.head_commit!(repo)
    check.issues.build(issues)

    check.mark_as_finished!
  rescue StandardError => e
    Rails.logger.error(e.message)
    Rollbar.error(e)

    check.mark_as_failed!
  end
end
