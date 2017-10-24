class AddFirstCost < ActiveRecord::Migration[5.1]
  def self.up
    execute "insert into Costs(id, cost, updated_at, created_at) values (1, 10,'2017-10-18 12:54:27.798498', '2017-10-18 12:54:27.798498')"
  end
end
