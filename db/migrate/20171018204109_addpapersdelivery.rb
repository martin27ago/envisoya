class Addpapersdelivery < ActiveRecord::Migration[5.1]
  def change
    change_table :deliveries do |t|
    end
    add_attachment :deliveries, :papers
  end
end