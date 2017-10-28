class Delivery < ActiveRecord::Base
  has_many :shippings
  validates :name, :presence => true
  validates :surname, :presence => true
  validates :document, :presence => true
  validates :password, :presence => true
  validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, :presence => true, :uniqueness => true
  has_attached_file :image, styles:{ medium: '200x200>', thumb: '48x48>'}
  has_attached_file :license
  has_attached_file :papers
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], styles:{ medium: '200x200>', thumb: '48x48>'}
  validates_attachment_content_type :license, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  #validates_attachment :papers, :content_type => ["application/pdf", "image/jpg"]
  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize do |delivery|
      delivery.provider = auth.provider
      delivery.uid = auth.uid
      delivery.name = auth.info.first_name
      delivery.surname = auth.info.last_name
      delivery.email = auth.info.email
      delivery.document = '123456789'
      delivery.password = '123'
      delivery.imageFacebook = auth.info.image
      delivery.oauth_token = auth.credentials.token
      delivery.oauth_expires_at = Time.at(auth.credentials.expires_at)
      delivery.active = false
      if delivery.save!
        Loghelper.Log 'info', 'Se registró el cadete'+ delivery.name+' '+ delivery.surname+ ' con Facebook.'
      else
        Loghelper.Log 'info', 'No se pudo registrar un cadete con Facebook.'
      end
    end
  end

  def self.signin (email, password)
    aux = Delivery.where(["email = ? AND password = ?", email, password]).first
    if(aux.nil?)
      return nil
    end
    Delivery.find(aux.id)
  end

  def self.selectDelivery (userFrom, addressFrom, addressTo)
    aux = Delivery.where(['active = ?', true]).first
    if(aux.nil?)
      return nil
    end
    delivery = Delivery.find(aux.id)
    ApplicationMailer.new_shipping_mail(delivery.email, userFrom, addressFrom, addressTo).deliver_later(wait: 1.minute)
    return delivery
  end
end