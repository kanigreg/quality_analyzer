# frozen_string_literal: true

class StorageStub
  class << self
    def repo_dest(_repo)
      Rails.root.join('test/fixtures/files/js_repo').to_s
    end

    def head_commit!(_dest)
      'fabdace'
    end

    def erase!(_repo); end
  end
end
