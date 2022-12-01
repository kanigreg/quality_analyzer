# frozen_string_literal: true

class GithubApiStub
  class << self
    def repository!(_id, _user)
      response = Rails.root.join('test/fixtures/files/repository.json').read
      JSON.parse(response, symbolize_names: true)
    end

    def repositories(_user)
      response = Rails.root.join('test/fixtures/files/repositories.json').read
      [JSON.parse(response, symbolize_names: true), :success]
    end

    def clone!(_repo, _dest); end

    def create_hook!(_repo, _urser); end

    def webhook_request?(_payload, _signature)
      true
    end
  end
end
