class ChangeBooleanName < ActiveRecord::Migration[5.1]
  def change
    rename_column :shippings, :fixedPrice, :estimatedPrice
  end
end
