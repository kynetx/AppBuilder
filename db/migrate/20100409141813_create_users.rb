class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :name
      t.integer :userid
      t.string :request_token
      t.string :request_secret
      t.string :access_token
      t.string :access_secret
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :expires # second representation of 2 weeks from creation.

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
