class ChangePaymentMedia < ActiveRecord::Migration[5.1]
  def change
    change_column :shippings, :paymentMedia, :string
  end
end
