class AddShippingPaymentMedia < ActiveRecord::Migration[5.1]
  def change
    change_table :shippings do |t|
      t.integer :paymentMedia
    end
  end
end