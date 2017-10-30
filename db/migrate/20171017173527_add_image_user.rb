class AddImageUser < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.rename :image, :imageFacebook
    end
    add_attachment :users, :image
  end
end
