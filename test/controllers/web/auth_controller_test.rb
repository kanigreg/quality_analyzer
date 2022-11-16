# frozen_string_literal: true

require 'test_helper'

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'check github auth request' do
    post auth_request_path(:github)

    assert_response :redirect
  end

  test 'should sign in github user' do
    auth_hash = Faker::Omniauth.github

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url(:github)

    assert_response :redirect

    user = User.find_by!(email: auth_hash[:info][:email].downcase)

    assert user.present?
    assert signed_in?
  end

  test 'should logout user' do
    sign_in users(:one)

    delete logout_path

    assert_not signed_in?
    assert_redirected_to root_path
  end
end
