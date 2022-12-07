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

  test 'should get show' do
    get repository_path(@repo)

    assert_response :success
  end

  test 'should get new' do
    get new_repository_path

    assert_response :success
  end

  test 'should post create' do
    post repositories_path, params: { repository: @attrs }

    repository = Repository.find_by(@attrs)

    assert { repository.present? }
    assert_redirected_to repositories_path
    assert_performed_jobs 1
  end
end
