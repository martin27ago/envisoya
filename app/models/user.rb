class User < ActiveRecord::Base
  validates :document, presence:  true,  length: {minimum: 1}, on: :edit
  validates :name, presence: true,  length: {minimum: 1}, on: :edit
  validates :surname, presence:true, length: {minimum: 1}, on: :edit
  validates :mail, presence: true,  length: {minimum: 1}, on: :edit

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
      user.save!
    end
  end
end
