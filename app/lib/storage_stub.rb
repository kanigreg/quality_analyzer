# frozen_string_literal: true

class StorageStub
  class << self
    def repo_dest(_dir_name)
      Rails.root.join('test/fixtures/files/repos/javascript').to_s
    end

    def head_commit!(_dest)
      'fabdace'
    end

    def erase(_dir_name)
      true
    end
  end
end
