# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repo = repositories(:quality_analyzer)

    sign_in @repo.user

    @attrs = { github_id: 123_456 }
  end

  test 'should get index' do
    get repositories_path

    assert_response :success
  end

  test 'should get show' do
    get repository_path(@repo)

    assert_response :success
  end

  test 'should deny access' do
    repo = repositories(:two)

    get repository_path(repo)

    assert_redirected_to root_path
  end

  test 'should get new' do
    VCR.use_cassette('repos_info_success') do
      get new_repository_path
    end

    assert_response :success
  end

  test 'should post create' do
    post repositories_path, params: { repository: @attrs }

    repository = Repository.find_by(@attrs)

    assert { repository.present? }
    assert_redirected_to repositories_path
    assert_enqueued_jobs 1
  end
end
