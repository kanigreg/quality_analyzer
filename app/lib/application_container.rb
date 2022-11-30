# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_api, -> { GithubApiStub }
    register :storage, -> { StorageStub }
  else
    register :github_api, -> { GithubApi }
    register :storage, -> { Storage }
  end
end
