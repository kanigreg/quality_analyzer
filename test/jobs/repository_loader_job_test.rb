# frozen_string_literal: true

require 'test_helper'

class RepositoryLoaderJobTest < ActiveJob::TestCase
  test 'should load repo' do
    repo = repositories(:unloaded)

    VCR.use_cassette('hook_created_success') do
      VCR.use_cassette('repo_info_success') do
        RepositoryLoaderJob.perform_now(repo.id)
      end
    end

    repo.reload

    assert { repo.fetched? }
    assert { repo.full_name.present? }
    assert { repo.language.present? }
  end
end
