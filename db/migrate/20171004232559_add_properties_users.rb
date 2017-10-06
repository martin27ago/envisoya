class AddPropertiesUsers < ActiveRecord::Migration[5.1]
  def up
    change_table :users do |t|
      t.string :image
    end
  end
end
