class AddDiscountAndFixedPrice < ActiveRecord::Migration[5.1]
  def change
    add_column :shippings, :fixedPrice, :boolean, :default => false
    add_column :shippings, :discount, :integer, :default => 0
  end
end