class DeliveryLatLong < ActiveRecord::Migration[5.1]
  change_table :deliveries do |t|
    t.string :longitude, :default =>"-56.14013671875"
    t.string :latitude, :default =>"-34.894942447397305"
  end
end
