# frozen_string_literal: true

require 'test_helper'

class RepositoryLoaderJobTest < ActiveJob::TestCase
  test 'should load repo' do
    repo = repositories(:unloaded)
    uri_template = Addressable::Template.new 'https://api.github.com/repositories/{id}'
    response = load_fixture('files/repository.json')

    stub_request(:get, uri_template)
      .to_return(
        status: 200,
        body: response,
        headers: { 'Content-Type' => 'application/json' }
      )

    RepositoryLoaderJob.perform_now(repo.id)

    repo.reload

    assert { repo.fetched? }
    assert { repo.full_name.present? }
    assert { repo.language.present? }
  end
end
