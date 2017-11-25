class CreateShipping < ActiveRecord::Migration[5.1]
  def change
    create_table :shippings do |t|
      t.string :latitudeFrom
      t.string :longitudeFrom
      t.string :latitudeTo
      t.string :longitudeTo
      t.string :emailTo
      t.decimal :price, precision: 10, scale: 2
      t.integer :status, default: 0
      t.string :postalCodeFrom
      t.string :postalCodeTo
      t.references :delivery
      t.references :user
      t.string :addressFrom
      t.string :addressTo
      t.timestamps
      t.decimal :weight
      t.decimal :weight
    end
  end
end
