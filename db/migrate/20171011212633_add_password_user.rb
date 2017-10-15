class AddPasswordUser < ActiveRecord::Migration[5.1]
  def up
    change_table :users do |t|
      t.string :password
    end
  end
end
