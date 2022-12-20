# frozen_string_literal: true

class GithubApiStub
  class << self
    def repository!(*_args)
      response = Rails.root.join('test/fixtures/files/repository.json').read
      JSON.parse(response, symbolize_names: true)
    end

    def repositories(*_args)
      response = Rails.root.join('test/fixtures/files/repositories.json').read
      [JSON.parse(response, symbolize_names: true), :success]
    end

    def clone!(*_args); end

    def create_hook!(*_args); end

    def webhook_request?(*_args)
      true
    end
  end
end
