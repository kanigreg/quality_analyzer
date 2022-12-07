class RenameGithubRepoIdInRepositories < ActiveRecord::Migration[7.0]
  def change
    rename_column :repositories, :github_repo_id, :github_id
  end
end
