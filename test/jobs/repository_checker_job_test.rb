# frozen_string_literal: true

require 'test_helper'

class RepositoryCheckerJobTest < ActiveJob::TestCase
  test 'should check js repo' do
    check = repository_checks(:checking)

    RepositoryCheckerJob.perform_now(check.id)

    check.reload

    assert { check.finished? }
    assert { check.reference.present? }
    refute { check.issues.empty? }
    refute { check.passed? }
  end

  test 'should check ruby repo' do
    check = repository_checks(:ruby_repo_checking)

    RepositoryCheckerJob.perform_now(check.id)

    check.reload

    assert { check.finished? }
    assert { check.reference.present? }
    refute { check.issues.empty? }
    refute { check.passed? }
  end
end
