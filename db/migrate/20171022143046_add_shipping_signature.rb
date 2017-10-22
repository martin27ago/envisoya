class AddShippingSignature < ActiveRecord::Migration[5.1]
  def change
    change_table :shippings do |t|
      t.integer :paymentMedia
    end
    add_attachment :shippings, :signature
  end
end