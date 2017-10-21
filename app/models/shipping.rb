class Shipping < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :delivery, class_name: "Delivery"
  enum status: [ :pending, :shipping, :received, :cancel ]
end