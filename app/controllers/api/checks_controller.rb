# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  def create
    verify_webhook!

    repo = Repository.find_by(github_repo_id: repository_params[:id])

    if repo.nil?
      error_mes = "Failed to check a repository with github_id: #{repository_params[:id]}"
      Rollbar.critical error_mes

      respond_with({ error: error_mes }, location: nil, status: :unprcessable_entity)
    end

    check = repo.checks.new

    if check.save
      RepositoryCheckerJob.perform_later(check.id)
    end

    respond_with(check, location: nil, status: :created)
  end

  private

  def repository_params
    params.require(:repository).permit(:id)
  end
end
