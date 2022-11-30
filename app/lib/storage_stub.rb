# frozen_string_literal: true

class StorageStub
  class << self
    def repo_dest(repo)
      Rails.root.join('test/fixtures/files/repos', repo.language).to_s
    end

    def head_commit!(_dest)
      'fabdace'
    end

    def erase!(_repo); end
  end
end
