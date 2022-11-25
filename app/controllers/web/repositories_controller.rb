# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  def index
    authenticate_user!

    @repositories = current_user.repositories
  end

  def new
    authenticate_user!

    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true

    @repository = current_user.repositories.new
    begin
      @optioins_for_repos =
        client.repos
              .select { |repo| Repository.language.values.include?(repo.language.downcase) }
              .map { |repo| [repo.name, repo.id] }
    rescue StandardError
      @optioins_for_repos = []
      flash.now[:alert] = t('.failure.fetch')
    end
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
    params.require(:repository).permit(:github_repo_id)
  end
end
