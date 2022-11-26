# frozen_string_literal: true

require 'test_helper'

class RepositoryLoaderJobTest < ActiveJob::TestCase
  test 'should load repo' do
    repo = repositories(:unloaded)

    RepositoryLoaderJob.perform_now(repo.id)

    repo.reload

    assert { repo.fetched? }
    assert { repo.full_name.present? }
    assert { repo.language.present? }
  end
end
