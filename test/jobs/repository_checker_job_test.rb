# frozen_string_literal: true

require 'test_helper'

class RepositoryCheckerJobTest < ActiveJob::TestCase
  test 'should check js repo' do
    check = repository_checks(:created)

    RepositoryCheckerJob.perform_now(check.id)

    check.reload

    assert { check.finished? }
    assert { check.reference.present? }
    assert { check.issues.empty? }
    assert { check.passed? }
  end

  test 'should check ruby repo' do
    check = repository_checks(:ruby_repo_check)

    RepositoryCheckerJob.perform_now(check.id)

    check.reload

    assert { check.finished? }
    assert { check.reference.present? }
    assert { check.issues.empty? }
    assert { check.passed? }
  end
end
