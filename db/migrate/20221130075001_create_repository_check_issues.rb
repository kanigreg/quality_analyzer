# frozen_string_literal: true

class CreateRepositoryCheckIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :repository_check_issues do |t|
      t.string :file_path
      t.string :message
      t.string :rule
      t.integer :line
      t.integer :column
      t.references :repository_check, null: false, foreign_key: true

      t.timestamps
    end
  end
end
