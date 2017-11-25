require 'uri'
require 'net/http'

class Shipping < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :delivery, class_name: "Delivery"
  enum status: [ :Pendiente, :Entregado, :Cancelado ]
  enum paymentMedia: [ :Contado, :Tarjeta ]
  has_attached_file :signature, styles: {thumbnail: "120x120>"}
  validates_attachment_content_type :signature, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def self.CalculateCost longitudeFrom, latitudeFrom, longitudeTo, latitudeTo, weight, user_id
    aux = CostsService.calculate_cost latitudeFrom,latitudeTo,longitudeFrom,longitudeTo,weight
    discount = Discount.where(["active = ? and used = ? and user_id = ?", true, false, user_id]).first
    percentage_discount = 0
    if(!discount.nil?)
      percentage_discount = discount.porcent
    end
    { 'discount' => percentage_discount, 'price' => aux['cost'], 'estimatedPrice' => aux['estimatedPrice'] }
  end

  def self.ConfirmPrice
    if CostsService.costs_updated
      shippings = Shipping.where(["\"estimatedPrice\" = ? and \"status\" = ?", true, 0])
      shippings.each do |shipping|
        cost = shipping.UpdateCost shipping
        shipping.price = cost['cost']
        shipping.estimatedPrice = false
        shipping.save!
        user = shipping.user
        User.SendConfirmationMail shipping, user
      end
    end
  end

  def UpdateCost shipping
    CostsService.calculate_cost shipping.latitudeFrom,shipping.latitudeTo,shipping.longitudeFrom,shipping.longitudeTo, shipping.weight
  end

  def self.DeliveredShipping
    if CostsService.costs_updated
      shippings = Shipping.where(["\"estimatedPrice\" = ? and \"status\" = ?", true, 1])
      shippings.each do |shipping|
        cost = shipping.UpdateCost shipping
        shipping.price = cost['cost']
        shipping.estimatedPrice = false
        shipping.save!
        User.DeliveredShipping shipping
      end
    end
  end

end