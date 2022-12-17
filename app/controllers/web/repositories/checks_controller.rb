# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  def show
    authenticate_user!

    @check = Repository::Check.includes(:issues).find(params[:id])
    @issues = @check.issues.group_by(&:file_path)
  end

  def create
    authenticate_user!

    repo = Repository.find(params[:repository_id])
    check = repo.checks.new

    authorize check

    if check.save
      RepositoryCheckerJob.perform_later(check.id)
      redirect_to repository_path(repo), notice: t('.success')
    else
      redirect_to repository_path(repo), alert: t('.failure')
    end
  end
end
