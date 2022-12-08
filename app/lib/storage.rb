# frozen_string_literal: true

class Storage
  class << self
    def repo_dest(dir_name)
      "/tmp/quality_analyzer/repos/#{dir_name}"
    end

    def head_commit!(dir_path)
      command = "git -C #{dir_path} rev-parse --short HEAD"
      commit_ref, error_mes, status = Open3.capture3(command)

      raise "Failed to retrive commit reference. #{error_mes}" unless status.success?

      commit_ref
    end

    def erase(dir_name)
      command = "rm -fr #{repo_dest(dir_name)}"
      _, _, status = Open3.capture3(command)

      status.success?
    end
  end
end
