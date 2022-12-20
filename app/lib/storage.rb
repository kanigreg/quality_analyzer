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

    def erase(dest)
      command = "rm -fr #{dest}"
      _, _, status = Open3.capture3(command)

      status.success?
    end

    def download!(repo, dir_name)
      dest = repo_dest(dir_name)
      github_repo = Octokit::Repository.new repo.full_name
      command = "git clone #{github_repo.url} #{dest}"
      _, error_mes, status = Open3.capture3(command)

      raise "Failed to clone repo. #{error_mes}" unless status.success?

      dest
    end
  end
end
