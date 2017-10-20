class CreateDelivery < ActiveRecord::Migration[5.1]
  def change
    create_table :deliveries do |t|
      t.boolean :active, :default => false
      t.string :provider
      t.string :uid
      t.string :name
      t.string :surname
      t.string :email
      t.string :password
      t.string :document
      t.string :imageFacebook
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.timestamps
    end
    add_attachment :deliveries, :image
    add_attachment :deliveries, :license
  end
end
