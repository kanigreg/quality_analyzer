class RenameStateColumnInRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    rename_column :repository_checks, :state, :aasm_state
  end
end
