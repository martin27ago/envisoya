class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :surname
      t.string :email, unique: true
      t.string :password
      t.string :document
      t.string :image
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.timestamps
    end
  end
end