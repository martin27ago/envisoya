class User < ActiveRecord::Base
  validates :document, :presence =>  true
  validates :name, :presence => true
  validates :surname, :presence => true
  validates :mail, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, :presence => true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.first_name
      user.surname = auth.info.last_name
      user.mail = auth.info.email
      user.image = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.document = '123456789'
      user.save!
    end
  end

  def self.signin (mail, password)
    aux = User.where(["mail = ? AND password = ?", mail, password]).first
    if(aux.nil?)
      return nil
    end
    User.find(aux.id)
  end
end
