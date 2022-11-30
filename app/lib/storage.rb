# frozen_string_literal: true

class Storage
  class << self
    def repo_dest(repo)
      "/tmp/quality_analyzer/repos/#{repo.github_repo_id}"
    end

    def head_commit!(repo)
      command = "git -C #{repo_dest(repo)} rev-parse --short HEAD"
      commit_ref, error_mes, status = Open3.capture3(command)

      raise "Failed to retrive commit reference. #{error_mes}" unless status.success?

      commit_ref
    end

    def erase!(repo)
      command = "rm -fr #{repo_dest(repo)}"
      _, error_mes, status = Open3.capture3(command)

      raise "Failed to remove sources directory. #{error_mes}" unless status.success?
    end
  end
end
