# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'
require 'vcr'

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def load_fixture(filename)
    Rails.root.join("test/fixtures/#{filename}").read
  end

  # Add more helper methods to be used by all tests here...
  VCR.configure do |c|
    c.cassette_library_dir = 'cassettes'
    c.hook_into :webmock
  end

  class ActionDispatch::IntegrationTest
    def sign_in(user)
      auth_hash = {
        provider: 'github',
        uid: '123456',
        info: {
          email: user.email,
          nickname: user.nickname,
          image: user.image_url
        },
        credentials: {
          token: user.token
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      get callback_auth_url(:github)
    end

    def signed_in?
      session[:user_id].present? && current_user.present?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
