class CreateDiscount < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.references :user
      t.references :userFrom
      t.integer :porcent
      t.timestamps
      t.boolean :used, :default => false
      t.boolean :active, :default => false
    end
  end
end
