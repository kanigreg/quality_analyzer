class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :nickname
      t.string :image_url
      t.string :token

      t.timestamps
    end
  end
end
