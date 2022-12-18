# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  def index
    authenticate_user!

    @repositories = current_user.repositories.includes(:checks)
  end

  def show
    authenticate_user!

    @repository = Repository.includes(:checks)
                            .order('repository_checks.created_at': :desc)
                            .find(params[:id])

    authorize @repository
  end

  def new
    authenticate_user!

    @repository = current_user.repositories.new

    # rubocop:disable Rails/SkipsModelValidations
    current_user.touch if params[:invalidate_cache]
    # rubocop:enable Rails/SkipsModelValidations

    @options_for_repos, status = current_user.repo_names

    flash.now[:alert] = t('.failure.fetch') if status == :failure
  end

  def create
    authenticate_user!

    @repository = current_user.repositories.new(repository_params)

    if @repository.save
      RepositoryLoaderJob.perform_later(@repository.id)
      redirect_to repositories_path, notice: t('.success')
    else
      flash[:alert] = t('.failure')
      redirect_to new_repository_path
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:github_id)
  end
end
