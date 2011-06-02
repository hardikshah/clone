class ChangeEmailAddressColumnInPosts < ActiveRecord::Migration
  def self.up
    remove_column :posts, :email_address
    add_column :posts, :email, :string
  end

  def self.down
    remove_column :posts, :email
    add_column :posts, :email_address, :string    
  end
end
