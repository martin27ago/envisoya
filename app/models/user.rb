class User < ActiveRecord::Base
  has_many :shippings
  has_many :discounts, foreign_key: "user_id", class_name: "Discount"
  has_many :discountsTransmitted, foreign_key: "userFrom_id", class_name: "Discount"
  validates :name, :presence => true
  validates :surname, :presence => true
  validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, :presence => true, :uniqueness => true
  has_attached_file :image, styles:{ medium: '200x200>', thumb: '48x48>'}
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], styles:{ medium: '200x200>', thumb: '48x48>'}
  before_save :encrypt_password

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.first_name
      user.surname = auth.info.last_name
      user.email = auth.info.email
      user.imageFacebook = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      if user.save!
        LoggerHelper.Log 'info', 'Se registró el usuario '+ user.name+' '+ user.surname+ ' con Facebook.'
      else
        LoggerHelper.Log 'error', 'No se pudo registrar usuario por Facebook.'
      end
    end
  end

  def self.signin (email, password)
    aux = User.where(["email = ? ", email]).first
    if aux.is_password?password
      User.find(aux.id)
    else
      return nil
    end
  end

  def self.exists_user_to email, sender
    if !User.exists?(["email = ?", email])
      ApplicationMailer.registry_mail(email,sender).deliver_later(wait: 1.minute)
    end
  end

  def self.send_confirmation_mail shipping, user
    if(!shipping.estimatedPrice)
      ApplicationMailer.send_shipping_confirmation(shipping, user).deliver_later(wait: 1.minute)
    end
  end

  def apply_discount
    discount = Discount.where(["active = ? and used = ? and user_id = ?", true, false, self.id]).first
    if(!discount.nil?)
      discount_from = Discount.where(["\"userFrom_id\" = ? and user_id = ? and active = ?", self.id, discount.userFrom, false]).first
      if !discountFrom.nil?
        discount_from.active = true
        discount_from.save!
      end
      discount.used = true
      discount.save!
      return discount.porcent
    end
    return 0
  end

  def self.delivered_shipping shipping
    if(!shipping.estimatedPrice)
      ApplicationMailer.shipping_delivered(shipping).deliver_later(wait: 1.minute)
    end
  end

  def encrypt_password
    if password.present?
      encryptedPassword = BCrypt::Password.create(self.password )
      self.password = encryptedPassword
    end
  end

  def is_password? password
    BCrypt::Password.new(self.password)==password
  end

end