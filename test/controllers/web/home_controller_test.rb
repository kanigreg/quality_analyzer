# frozen_string_literal: true

require 'test_helper'

class Web::HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get web_home_show_url
    assert_response :success
  end
end
