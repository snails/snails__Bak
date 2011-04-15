class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password
      t.string :salt
      t.boolean :admin,                        :default =>false
      t.boolean :actived,                      :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
