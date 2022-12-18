# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'should post create check' do
    body = load_fixture('files/webhook.json')

    post api_checks_path(format: :json), params: JSON.parse(body)

    data = JSON.parse(response.body)
    check = Repository::Check.find(data['id'])

    assert_response :success
    assert { check.present? }
    assert_performed_jobs 1
  end
end
