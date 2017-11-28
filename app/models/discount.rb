class Discount < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :userFrom, class_name: "User"
  def self.manage_discount user, user_from_id
    user_from = User.where(["id = ?", user_from_id]).first
    discount = Discount.new
    discount.user = user
    discount.userFrom = user_from
    discount.porcent = 50
    discount.active = true
    discount.save!

    discountFrom = Discount.new
    discountFrom.user = user_from
    discountFrom.user_from = user
    discountFrom.porcent = 50
    discountFrom.active = false
    discountFrom.save!
  end
end