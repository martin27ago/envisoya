require 'uri'
require 'net/http'

class Shipping < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :delivery, class_name: "Delivery"
  enum status: [ :Pendiente, :Entregado, :Cancelado ]
  enum paymentMedia: [ :Contado, :Tarjeta ]
  has_attached_file :signature, styles: {thumbnail: "120x120>"}
  validates_attachment_content_type :signature, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def self.calculate_cost longitude_from, latitude_from, longitude_to, latitude_to, weight, user_id
    aux = CostsService.calculate_cost latitude_from,latitude_to,longitude_from,longitude_to,weight
    discount = Discount.where(["active = ? and used = ? and user_id = ?", true, false, user_id]).first
    percentage_discount = 0
    if(!discount.nil?)
      percentage_discount = discount.porcent
    end
    { 'discount' => percentage_discount, 'price' => aux['cost'], 'estimatedPrice' => aux['estimatedPrice'] }
  end

  def self.confirm_price
    if CostsService.costs_updated
      shippings = Shipping.where(["\"estimatedPrice\" = ? and \"status\" = ?", true, 0])
      shippings.each do |shipping|
        cost = shipping.update_cost shipping
        shipping.price = cost['cost']
        shipping.estimatedPrice = false
        shipping.save!
        user = shipping.user
        User.send_confirmation_mail shipping, user
      end
    end
  end

  def update_cost shipping
    CostsService.calculate_cost shipping.latitudeFrom,shipping.latitudeTo,shipping.longitudeFrom,shipping.longitudeTo, shipping.weight
  end

  def self.delivered_shipping
    if CostsService.costs_updated
      shippings = Shipping.where(["\"estimatedPrice\" = ? and \"status\" = ?", true, 1])
      shippings.each do |shipping|
        cost = shipping.update_cost shipping
        shipping.price = cost['cost']
        shipping.estimatedPrice = false
        shipping.save!
        User.delivered_shipping shipping
      end
    end
  end

end