class User < ActiveRecord::Base
  has_many :shippings
  validates :document, :presence =>  true
  validates :name, :presence => true
  validates :surname, :presence => true
  validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, :presence => true
  has_attached_file :image, styles:{ medium: '200x200>', thumb: '48x48>'}
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], styles:{ medium: '200x200>', thumb: '48x48>'}

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.first_name
      user.surname = auth.info.last_name
      user.email = auth.info.email
      user.imageFacebook = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.document = '123456789'
      user.password = '123'
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
<<<<<<< HEAD
end
=======

  def self.ExistUserReceiver email, sender
    if !User.exists?(["email = ?", email])
      ApplicationMailer.registry_mail(email,sender).deliver_now
    end
  end
end
>>>>>>> 2198e903fd3131a9a4d54da7955190d383c11192
