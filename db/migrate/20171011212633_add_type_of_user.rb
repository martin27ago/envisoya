class AddTypeOfUser < ActiveRecord::Migration[5.1]
  def up
    change_table :users do |t|
      t.integer :typeUser, default: 0
    end
  end
end
