class User < ActiveRecord::Base
  has_many :shippings
  has_many :discounts, foreign_key: "user_id", class_name: "Discount"
  has_many :discountsTransmitted, foreign_key: "userFrom_id", class_name: "Discount"
  validates :name, :presence => true
  validates :document, :presence => true
  validates :password, :presence => true
  validates :surname, :presence => true
  validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, :presence => true, :uniqueness => true
  has_attached_file :image, styles:{ medium: '200x200>', thumb: '48x48>'}
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], styles:{ medium: '200x200>', thumb: '48x48>'}

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.first_name
      user.surname = auth.info.last_name
      user.email = auth.info.email
      user.imageFacebook = auth.info.image
      user.document ='123456789'
      user.password = '123'
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def self.signin (email, password)
    aux = User.where(["email = ? AND password = ?", email, password]).first
    if(aux.nil?)
      return nil
    end
    User.find(aux.id)
  end

  def self.ExistUserReceiver email, sender
    if !User.exists?(["email = ?", email])
      ApplicationMailer.registry_mail(email,sender).deliver_later
    end
  end

  def applyDiscount
    discount = Discount.where(["active = ? and used = ? and user_id = ?", true, false, self.id]).first
    if(!discount.nil?)
      discountFrom = Discount.where(["userFrom = ? and user_id = ? and active = ?", self.id, discount.userFrom, false]).first
      discountFrom.active = true
      discountFrom.save!
      discount.used = true
      discount.save!
      return discount.porcent
    end
    return 0
  end
end