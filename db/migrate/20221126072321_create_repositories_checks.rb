# frozen_string_literal: true

class CreateRepositoriesChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :repository_checks do |t|
      t.string :state
      t.string :reference
      t.boolean :passed
      t.integer :issues_count
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
