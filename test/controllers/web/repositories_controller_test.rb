# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repo = repositories(:one)

    sign_in @repo.user

    @attrs = { github_repo_id: 123_456 }
  end

  test 'should get index' do
    get repositories_path

    assert_response :success
  end

  test 'should get new' do
    response = load_fixture('files/repositories.json')

    stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
      .to_return(
        status: 200,
        body: response,
        headers: { 'Content-Type': 'application/json' }
      )

    get new_repository_path

    assert_response :success
  end

  test 'should post create' do
    post repositories_path, params: { repository: @attrs }

    repository = Repository.find_by(@attrs)

    assert { repository.present? }
    assert_redirected_to repositories_path
    assert_enqueued_with job: RepositoryLoaderJob
  end
end
