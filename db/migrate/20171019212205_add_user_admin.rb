class AddUserAdmin < ActiveRecord::Migration[5.1]
  def self.up
    execute "insert into users (id, name, surname, email, password, document, imageFacebook, admin, created_at, updated_at) values (100, 'Admin', 'Admin', 'admin@admin.com','admin', '123456789', 'http://graph.facebook.com/v2.6/10154738137286556/picture',1, '2017-10-18 12:54:27.798498', '2017-10-18 12:54:27.798498')"
  end
end
