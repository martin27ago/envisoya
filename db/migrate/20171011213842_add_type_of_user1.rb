class AddTypeOfUser1 < ActiveRecord::Migration[5.1]
  def up
    rename_column :users, :type, :typeUser
  end
end
