# frozen_string_literal: true

class StorageStub
  class << self
    def repo_dest(*_args)
      Rails.root.join('test/fixtures/files/repos/javascript').to_s
    end

    def head_commit!(*_args)
      'fabdace'
    end

    def erase(*_args)
      true
    end

    def clone!(*_args)
      repo_dest
    end
  end
end
