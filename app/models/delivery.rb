class Delivery < ActiveRecord::Base
  validates :document, :presence =>  true
  validates :name, :presence => true
  validates :surname, :presence => true
  validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, :presence => true
  has_attached_file :image, styles:{ medium: '200x200>', thumb: '48x48>'}
  has_attached_file :license, styles:{ medium: '200x200>', thumb: '48x48>'}
  has_attached_file :papers, styles: {thumbnail: "60x60#"}
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_content_type :license, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment :papers, content_type: { content_type: "application/pdf" }
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |delivery|
      delivery.provider = auth.provider
      delivery.uid = auth.uid
      delivery.name = auth.info.first_name
      delivery.surname = auth.info.last_name
      delivery.email = auth.info.email
      delivery.imageFacebook = auth.info.image
      delivery.oauth_token = auth.credentials.token
      delivery.oauth_expires_at = Time.at(auth.credentials.expires_at)
      delivery.document = '123456789'
      delivery.password = '123'
      delivery.active = false
      delivery.save!
    end
  end

  def self.signin (email, password)
    aux = Delivery.where(["email = ? AND password = ?", email, password]).first
    if(aux.nil?)
      return nil
    end
    Delivery.find(aux.id)
  end
end