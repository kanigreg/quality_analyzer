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
  end

  def new
    authenticate_user!

    @repository = current_user.repositories.new

    github_api = ApplicationContainer['github_api']
    repos, status = github_api.repositories(current_user)
    @options_for_repos =
      repos.select { |repo| Repository.language.values.include?(repo[:language]&.downcase) }
           .map { |repo| [repo[:name], repo[:id]] }

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
      render :new, status: :unprocessable_entity
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:github_id)
  end
end
