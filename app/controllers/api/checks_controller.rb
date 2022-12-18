# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  def create
    verify_webhook!

    repo = Repository.find_by!(github_id: repository_params[:id])

    check = repo.checks.new

    if check.save
      RepositoryCheckerJob.perform_later(check.id)
    end

    respond_with(check.as_json, location: nil, status: :ok)
  end

  private

  def repository_params
    params.require(:repository).permit(:id)
  end
end
