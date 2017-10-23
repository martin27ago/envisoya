class Discount < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :userFrom, class_name: "User"
  def self.ManageDiscount user, userFromId
    userFrom = User.where(["id = ?", userFromId]).first
    discount = Discount.new
    discount.user = user
    discount.userFrom = userFrom
    discount.porcent = 50
    discount.active = true
    discount.save!

    discountFrom = Discount.new
    discountFrom.user = userFrom
    discountFrom.userFrom = user
    discountFrom.porcent = 50
    discountFrom.active = false
    discountFrom.save!
  end
end