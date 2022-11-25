class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|
      t.integer :github_repo_id, index: true, unique: true
      t.string :name
      t.string :full_name
      t.string :language
      t.string :state
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
